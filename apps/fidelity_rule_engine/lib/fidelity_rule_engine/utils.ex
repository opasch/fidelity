defmodule FidelityRuleEngine.Utils do
  alias FidelityRuleEngine.Serializer
  require Logger

  def extract_endpoint!(n_value) do
    result =
      n_value
      |> String.split("/")
      |> Enum.fetch(0)

    case result do
      :error ->
        {:error, nil}

      {:ok, param_value} ->
        {:ok, param_value}
    end
  end

  def extract_resources(%{"payload" => message} = _event) do
    resources_list =
      message
      |> Serializer.Json.decode_message!()
      |> Enum.map(fn name -> Map.get(name, "n") end)

    {:ok, resources_list}
  end

  def extract_cart_id(%{"cart_id" => cart_id} = _event) do
    {:ok, cart_id}
  end

  def extract_cart_id(%{:cart_id => cart_id} = _event) do
    {:ok, cart_id}
  end

  def extract_merchant_id(%{"merchant_id" => merchant_id} = _event) do
    {:ok, merchant_id}
  end

  def extract_merchant_id(%{:merchant_id => merchant_id} = _event) do
    {:ok, merchant_id}
  end

  def extract_client_address(%{"client_address" => client_address} = _event) do
    {:ok, client_address}
  end

  def extract_client_address(%{:client_address => client_address} = _event) do
    {:ok, client_address}
  end

  def extract_total_price(%{"total_price" => total_price} = _event) do
    {:ok, total_price}
  end

  def extract_total_price(%{:total_price => total_price} = _event) do
    {:ok, total_price}
  end

  def extract_total_items(%{"total_items" => total_items} = _event) do
    {:ok, total_items}
  end

  def extract_total_items(%{:total_items => total_items} = _event) do
    {:ok, total_items}
  end

  def extract_items(%{"items" => message} = _event) do
    {:ok, message}
  end

  def extract_items(%{:items => message} = _event) do
    {:ok, message}
  end


  @doc """

  ## Examples
  iex> Udf.Utils.extract_entries(%{"name" => "test", "entries" => [%{"value" => 58.0}]},"value")
  ** (Protocol.UndefinedError) protocol Enumerable not implemented for nil. This protocol is implemented for: Date.Range, File.Stream, Function, GenEvent.Stream, HashDict, HashSet, IO.Stream, KafkaEx.Stream, List, Map, MapSet, Range, Stream
      (elixir) /home/vagrant/2018-08-14_11-20-47/scripts/elixir/deb/elixir_1.7.2-1/lib/elixir/lib/enum.ex:1: Enumerable.impl_for!/1
      (elixir) /home/vagrant/2018-08-14_11-20-47/scripts/elixir/deb/elixir_1.7.2-1/lib/elixir/lib/enum.ex:141: Enumerable.reduce/3
      (elixir) lib/enum.ex:1874: Enum.reduce/2
  iex> Udf.Utils.extract_entries(%{"name" => "test", "entries" => [%{"value" => 58.0}]},"entries")
  %{"value" => 58.0}

  """
  @spec extract_entries(map, term) :: map | term
  def extract_entries(message, param) do
    message1 =
      message
      |> Map.get(param)
      |> Enum.reduce(&Map.merge/2)

    message1
  end

  @doc """

  ## Examples
  iex> Udf.Utils.extract_entries!(%{"name" => "test", "entries" => [%{"value" => 58.0}]},"value")
  {:error, "{\"Error\":\"Parameter not Found\"}"}
  iex> Udf.Utils.extract_entries!(%{"name" => "test", "entries" => [%{"value" => 58.0}]},"entries")
  {:ok, %{"value" => 58.0}}
  iex>

  """
  def extract_entries!(message, param) do
    case Map.get(message, param) do
      nil ->
        Logger.debug(fn -> "{\"Status\":\"error parsing payload\"}" end)
        {:error, "{\"Error\":\"Parameter not Found\"}"}

      new_map ->
        {:ok, Enum.reduce(new_map, &Map.merge/2)}
    end
  end

  def extract_values!(message, param) do
    message1 =
      message
      |> Map.get(param)

    message1
  end

  def extract_values(message, param) do
    # IO.inspect(param)
    # IO.inspect(message)

    case Map.get(message, param) do
      nil ->
        # Logger.debug(fn -> "{\"error\":\"error parsing payload\"}" end)
        {:error, "{\"Error\":\"Parameter not Found\"}"}

      new_map ->
        {:ok, new_map}
    end
  end

  def validate_payload(message) do
    case Serializer.Json.decode_message(message) do
      {:ok, new_message} ->
        {:ok, new_message}

      {:error, _} ->
        Logger.debug(fn -> "{\"Status\":\"error parsing payload\"}" end)
        {:error, :reason}
    end
  end

  def check_timestamp(timestamp) do
    case DateTime.from_iso8601(timestamp) do
      {:ok, date_trans, _} ->
        DateTime.to_unix(date_trans)

      _ ->
        DateTime.to_unix(DateTime.utc_now() / 0)
    end
  end

  @doc """
  Finds all the elements in a list that match a given pattern.
  """
  def all_matches(collection) do
    Enum.filter(collection, fn element ->
      # match?({:fruit, _}, element)
      String.contains?(element, "metadata")
    end)
  end
end
