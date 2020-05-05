defmodule FidelityRuleEngine.Interfaces.HealthInterface do
  @moduledoc false
  # use FidelityRuleEngine,



    alias FidelityRuleEngine.Utils

    def health() do
      timestamp = DateTime.to_iso8601(DateTime.utc_now(), :extended)
      {:ok, hostname} = :inet.gethostname()

      response_meta({timestamp, hostname})

      # |> IO.inspect()
    end

    def response_meta({timestamp, hostname}) do
      %{
        ok: timestamp,
        hostname: to_string(hostname),
        node: Node.self(),
        connected_to: Node.list()
      }
    end
end
