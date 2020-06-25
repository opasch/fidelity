defmodule FidelityRuleEngine.RulesSetTest do
  use ExUnit.Case
  use FidelityRuleEngine.RepoCase

  test "List Merchant_Id Rules Set" do
    rules_list = FidelityRuleEngine.Interfaces.RulesSetInterfaces.rules_set_lookup("1234")
    assert rules_list == %{response: []}
    # IO.inspect(rules_list)
  end

  test "Add Group Rules fails, missing rules " do
    # Adding One Rule
    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "test",
        "priority" => 1,
        "description" => "",
        "actions" => ["store"],
        "condition" => %{"ti_gt" => 4}
      })

    add_rule =
      FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{
        "merchant_id" => "1234",
        "rules" => ["test", "Group_test"]
      })

    assert add_rule == %{response: "One of the rule does not exist"}
  end

  test "Add Rules Set " do
    # Adding One Rule
    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "test_1",
        "priority" => 1,
        "description" => "",
        "actions" => ["store"],
        "condition" => %{"ti_gt" => 4}
      })

    # Adding Second Rule
    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "test_2",
        "priority" => 1,
        "description" => "",
        "actions" => ["store"],
        "condition" => %{"ti_gt" => 4}
      })

    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "Group_test",
        "description" => "This is a test rule group",
        "priority" => 1,
        "rules" => ["test_1", "test_2"],
        "type" => "unit_rule_group"
      })

    add_rule =
      FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{
        "merchant_id" => "1234",
        "rules" => ["test_1", "Group_test"]
      })

    assert add_rule == %{response: %{rules: ["test_1", "Group_test"]}}
  end
end
