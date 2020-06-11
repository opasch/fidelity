defmodule FidelityRuleEngine.Stages.MessageHandler do
  use Broadway
  require Logger
  alias FidelityRuleEngine.{Validator, Serializer, Config}
  alias Broadway.Message
  # alias FidelityRuleEngine.Interface.DbProducer
  # alias FidelityRuleEngine.Process.Normalizor
  # alias FidelityRuleEngine.Schema.{DbStruct, DbMeta}

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: FidelityRuleEngine.Consumer,
      producer: [
        # default: [
        module: {
          BroadwayRabbitMQ.Producer,
          #  requeue: :once,
          queue: Config.fidelity_broker_normalized_queue(),
          connection: [
            username: Config.fidelity_broker_username(),
            password: Config.fidelity_broker_password(),
            host: Config.fidelity_broker_host(),
            port: Config.fidelity_broker_host_port()
          ],
          qos: [
            prefetch_count: 50
          ],
          on_failure: :reject,
          metadata: [:headers, :user_id]
        },
        concurrency: 5
        # ]
      ],
      processors: [
        default: [concurrency: 2]
      ]
      # ],
      # batchers: [
      #   blockchain: [stages: 1, batch_size: 1],
      #   other appS: [stages: 1, batch_size: 1]
      # ]
    )
  end

  def handle_message(
        _,
        %Message{data: data, metadata: %{headers: [{"merchant_id", :longstr, merchant_id}]}} =
          message,
        _
      ) do
    :ok =
      Logger.debug(fn -> "FidelityRuleEngine: Consumer Original Received Payload: " <> data end)

    # message
    # |> IO.inspect(label: "Got Message")

    # IO.inspect(merchant_id, label: "Received Merchant_id")
    # IO.inspect(data, label: "Received date")

    try do
      # with {:ok, new_message} <- decode_payload(data, []),
      with {:ok, new_message} <- Serializer.Json.decode_message(data),
           {:ok, _} <- Validator.validate(new_message, merchant_id) do
        # IO.inspect(new_message)
        Logger.debug(fn ->
          "FidelityRuleEngine message: Aligned with Internal Data Broker Schema"
        end)

        # TODO: Case Rule Engine returns empty string return failed message; skip batcher; simply ack
        FidelityRuleEngine.RuleEngines.Engine.main(new_message)
        # |> IO.inspect(label: " Rule Engine Output")

        message
      else
        {:error, reason} ->
          # IO.inspect reason
          Logger.debug(fn -> "FidelityRuleEngine: [Error Event] #{reason}" end)
          Message.failed(message, reason)

        {:service_unavailable, "Service Unavailable"} ->
          Logger.debug(fn -> "FidelityRuleEngine: Message Broker Service Unavailable" end)
          Message.failed(message, "FidelityRuleEngine: Message Broker Service Unavailable")

        {:not_acceptable, reason} ->
          Logger.debug(fn -> "FidelityRuleEngine: [Error Event] #{reason}" end)
          Message.failed(message, "FidelityRuleEngine: [Error Event] #{reason}")
      end
    rescue
      ArgumentError ->
        Logger.debug(fn -> "FidelityRuleEngine: Internal Error Unrecognized Data Format" end)
        Message.failed(message, "FidelityRuleEngine: Internal Error Unrecognized Data Format")
        # message
    end
  end

  def handle_message(_, message, _) do
    :ok = Logger.debug(fn -> "FidelityRuleEngine: Missing Merchant ID from received Payload" end)
    Message.failed(message, "FidelityRuleEngine: Missing Merchant ID from received Payload")
  end

  # @impl true
  # def handle_batch(:senml, messages, _batch_info, _context) do
  #   # Send batch of messages to Normalized queue
  #   IO.inspect messages, label: "Batcher SenML"
  # end

  # def handle_batch(:ld, messages, _batch_info, _context) do
  #   # Send batch of messages to Consumer queue
  #   IO.inspect messages, label: "Batcher LD"
  # end

  # defp decode_payload(message, opts \\ []) do
  #   case Jason.decode(message, opts) do
  #     {:ok, new_message} ->
  #       {:ok, new_message}

  #     {:error, _} ->
  #       {:error, "{\"Error\":\"error decoding payload\"}"}
  #   end
  # end

  # defp encode_payload(message) do
  #   case Jason.encode(message) do
  #     {:ok, new_message} ->
  #       {:ok, new_message}

  #     {:error, _} ->
  #       {:error, "{\"Error\":\"error encoding payload\"}"}
  #   end
  # end

  # defp extract_payload(message, param) do
  #   case get_in(message, param) do
  #     nil ->
  #       {:error, "{\"Error\":\"error parsing payload\"}"}

  #     param_value ->
  #       {:ok, param_value}
  #   end
  # end

  def make_mapper(key_list) do
    to_new_key = Map.new(key_list)

    fn {key, value}, new_map ->
      # case Map.fetch(to_new_key, Atom.to_string(key)) do
      case Map.fetch(to_new_key, key) do
        {:ok, new_key} ->
          # (4a)
          Map.put(new_map, new_key, value)

        _ ->
          # (4b)
          new_map
      end
    end
  end

  def transform(row_list, key_list) do
    #
    # 5) create key_mapper function to reuse on each map/row in row_list
    #
    key_mapper = make_mapper(key_list)

    for row <- row_list,
        do: Enum.reduce(row, %{}, key_mapper)
  end
end
