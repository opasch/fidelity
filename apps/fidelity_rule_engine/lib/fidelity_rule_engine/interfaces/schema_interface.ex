defmodule FidelityRuleEngine.Interfaces.SchemaInterfaces do
  @moduledoc """
  Controller to handle endpoint routes
  """
  require Logger

  @module __MODULE__

  # alias FidelityRuleEngine.Serializer
  alias FidelityRuleEngine.Tables.Schema
  alias FidelityRuleEngine.Utils

  @doc """
  Get Templates from Mapping

  Returns : json response

  """
  @spec schema_lookup(String.t()) :: Map.t()
  def schema_lookup(merchant_id) do
    # TODO: add detailed error message handling later
    rule_set_lookup_result = FidelityRuleEngine.Tables.Schema.lookup(merchant_id)
    Utils.render(rule_set_lookup_result)
  end

  @doc """
  Add rule set to db

  Returns : json response

  """
  @spec add_schema(Map.t()) :: Map.t()
  def add_schema(
        %{
          "merchant_id" => merchant_id,
          "schema" => schema
        } = schema_set
      ) do
    Utils.render(Schema.add(schema_set))
  end

  def add_schema(_) do
    Logger.info("#{@module}: Wrong payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"merchant_id\" => merchant_id,\"schema\" => schema}"
    )
  end

  @spec delete_schema(Map.t()) :: Map.t()
  def delete_schame(
        %{
          "merchant_id" => merchant_id
        } = schema_set
      ) do
    Utils.render(Schema.remove(schema_set))
  end

  def delete_schema(_) do
    Logger.info("#{@module}: Wrong Payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"merchant_id\" => merchant_id,\"schema\" => schema}"
    )
  end
end
