defmodule FidelityRuleEngine.Interfaces.RulesGroupInterface do
  @moduledoc """
  Controller to handle endpoint routes
  """
  require Logger

  @module __MODULE__

  # alias FidelityRuleEngine.Serializer
  alias FidelityRuleEngine.Tables.RulesGroup
  alias FidelityRuleEngine.Utils

  @doc """
  Get Rules List from Mapping

  Returns : json response

  """
  @spec rules_list(String.t()) :: Map.t()
  def rules_list(merchant_id) do
    Utils.render(RulesGroup.list(merchant_id))
  end

  @spec rule_lookup(String.t(), String.t()) :: Map.t()
  def rule_lookup(merchant_id, name) do
    # TODO: add detailed error message handling later
    # IO.inspect id 
    case RulesGroup.lookup(merchant_id, name) do
      # [{^name, msg}] -> msg 
      {:ok, msg} ->
        Utils.render(msg)

      :notfound ->
        Utils.render("RuleGroup not found")
    end
  end

  @doc """
  Add rule group to database

  Returns :  json response

  """
  @spec add_rule(Plug.Conn.t()) :: Plug.Conn
  # def add_device(%{"deviceId" => device_id, "deviceCloud" => device_cloud, "resourcesList" => resources_list}} = body_params) when is_list(group_rules_list) do
  def add_rule(%{
        "merchant_id" => merchant_id,
        "name" => name,
        "priority" => priority,
        "description" => description,
        "type" => type,
        "rules" => rules
      }) do
    with {:ok, rules_checked} <-
           FidelityRuleEngine.RulesHelper.check_rules(merchant_id, rules) do
      # description_text = "# RuleGroup description\nRules: #{rules}\nUser description:\n"

      rule_group = %{
        merchant_id: merchant_id,
        name: merchant_id <> "_" <> name,
        priority: priority,
        type: String.to_existing_atom(type),
        # description: description_text <> description,
        description: description,
        rules: rules_checked
      }

      Utils.render(RulesGroup.add(rule_group))
    else
      {:error, reason} ->
        Utils.render(reason)
    end
  end

  def add_rule(_) do
    Logger.info("#{@module}: Wrong Payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"name\" => name,\"priority\" => priority,\"description\" => description,\"type\" => type,\"rules\" => rules}"
    )
  end

  @spec delete_rule(String.t(), String.t()) :: Map.t()
  def delete_rule(merchant_id, id) do
    # TODO: add detailed error message handling later
    # IO.inspect id 
    case RulesGroup.delete(merchant_id, id) do
      # [{^name, msg}] -> msg 
      :ok ->
        Utils.render("Deleted")

      :error ->
        Utils.render("Rule not found")
    end
  end
end
