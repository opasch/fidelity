defmodule FidelityRuleEngine.RuleEngines.Engine do
  use RulesEngine

  @doc """
  Main funtion that sets all paremetes/rules for the rule engine fire
  """
  def main(event) do
    # IO.inspect(event)
    params = RulesEngineParameters.create(%{skip_on_first_applied_rule: false})
    merchant_id = event |> Map.get("merchant_id")
    IO.inspect(event)
    # TODO RuleSet Lookup needs to return a list
    rules_set =
      with {:ok, %{rules: list_result}} <- FidelityRuleEngine.Tables.RulesSet.lookup(merchant_id),
           {:ok, list_rules} <-
             FidelityRuleEngine.RulesHelper.get_actual_rules(merchant_id, list_result),
           {:ok, list_group_rules} <-
             FidelityRuleEngine.RulesHelper.get_actual_rules_group(merchant_id, list_result) do
        list_rules ++ Enum.map(list_group_rules, &RuleGroup.create(&1))
      else
        _ ->
          []
      end

    rules = Rule.add_rules(rules_set)

    fire(params, rules, event)
  end
end
