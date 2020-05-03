defmodule FidelityRuleEngine.RuleEngines.Engine do
  use RulesEngine

  # def main(merchant_id, event) do
  def main(event) do
    # IO.inspect(event)
    params = RulesEngineParameters.create(%{skip_on_first_applied_rule: false})

    rules_set =
      with {:ok, list_result} <- FidelityRuleEngine.Tables.RulesSet.lookup(event.merchant_id),
           {:ok, list_rules} <-
             FidelityRuleEngine.RulesHelper.get_actual_rules(event.merchant_id, list_result),
           {:ok, list_group_rules} <-
             FidelityRuleEngine.RulesHelper.get_actual_rules_group(event.merchant_id, list_result) do
        list_rules ++ Enum.map(list_group_rules, &RuleGroup.create(&1))
      else
        _ ->
          []
      end

    rules = Rule.add_rules(rules_set)

    fire(params, rules, event)
  end
end
