defmodule FidelityRuleEngine.Validator do
  @moduledoc """
  Module responsible to validate the received payload against Json schema


  """

  require Logger

  def validate(payload) do
      # IO.inspect payload
    cond do
      
      ExJsonSchema.Validator.valid?(FidelityRuleEngine.Tables.Schema.lookup!("schema"), payload) ->
        # Logger.debug(fn -> "FidelityRuleEngine message: Aligned with Internal Data Broker Schema" end)
        {:ok, payload}

      true ->
        # Logger.debug(fn -> "FidelityRuleEngine message: No Valid Schema detected" end)
        {:error, "No Valid Schema Detected or payload not according to defined schema"}
    end
  end
end
