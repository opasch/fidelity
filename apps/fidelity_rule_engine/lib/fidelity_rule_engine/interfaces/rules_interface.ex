defmodule FidelityRuleEngine.Interfaces.RulesInterface do
  @moduledoc """
  Interface module to handle Rules requests
  """
  require Logger

  @module __MODULE__

  alias FidelityRuleEngine.Tables.Rules
  alias FidelityRuleEngine.Utils

  @doc """
  Get Templates from Mapping

  Returns : json response

  """
  def rules_list(merchant_id) do
    Utils.render(Rules.list(merchant_id))
  end

  @spec rule_lookup(String.t(), String.t()) :: map()
  def rule_lookup(merchant_id, id) do
    case Rules.lookup(merchant_id, id) do
      # [{^name, msg}] -> msg 
      {:ok, msg} ->
        Utils.render(msg)

      :notfound ->
        Utils.render("Rule not found")
    end
  end

  @doc """
  Add rule to engine

  Returns : json response

  """

  def add_rule(%{
        "merchant_id" => merchant_id,
        "name" => name,
        "priority" => priority,
        "description" => description,
        "actions" => actions,
        "condition" => condition
      }) do
    with {:ok, _condition_checked} <-
           FidelityRuleEngine.RuleLogic.Conditions.check_conditions(condition),
         {:ok, _actions_checked} <- FidelityRuleEngine.RuleLogic.Actions.check_actions(actions) do
      rule = %{
        merchant_id: merchant_id,
        name: merchant_id <> "_" <> name,
        priority: priority,
        # description: description_text <> description,
        description: description,
        # condition: condition_checked,
        condition: condition,
        # actions: actions_checked
        actions: actions
      }

      # Utils.render(Rules.add(merchant_id <> "_" <> name, rule))
      Utils.render(Rules.add(rule))
    else
      {:error, reason} ->
        Utils.render(reason)
    end
  end

  def add_rule(_) do
    Logger.info("#{@module}: Wrong Payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"name\" => name,\"priority\" => priority,\"description\" => description,\"actions\" => actions,\"condition\" => condition}"
    )
  end

  @spec delete_rule(String.t(), String.t()) :: map()
  def delete_rule(merchant_id, name) do
    # TODO: add detailed error message handling later
    # IO.inspect id 
    case Rules.delete(merchant_id, name) do
      # [{^name, msg}] -> msg 
      :ok ->
        Utils.render("Deleted")

      :error ->
        Utils.render("Rule not found")
    end
  end
end
