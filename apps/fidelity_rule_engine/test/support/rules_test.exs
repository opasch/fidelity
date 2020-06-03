defmodule FidelityRuleEngine.RulesTest do
  use ExUnit.Case
  use FidelityRuleEngine.RepoCase
  test "List all Rules" do

    rules_list = FidelityRuleEngine.Interfaces.RulesInterface.rules_list
    assert rules_list == %{response: []}
    IO.inspect rules_list

  end

  test "Add Rule" do

    add_rule = FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{"merchant_id" => "1234", "name" => "test", "priority" => 1, "description" => "", "actions" => ["store"], "condition" => %{"ti_gt" => 4}})
    assert add_rule == %{response: %{actions: ["store"], condition: %{"ti_gt" => 4}, description: "", name: "1234_test", priority: 1}}
    IO.inspect add_rule
  end


  test "List Rule" do

    add_rule = FidelityRuleEngine.Interfaces.RulesInterface.rule_lookup("1234", "test")
    assert add_rule == %{response: %{actions: ["store"], condition: %{"ti_gt" => 4}, description: "", name: "1234_test", priority: 1}}
  end

  test "List Non Existent Rule" do

    add_rule = FidelityRuleEngine.Interfaces.RulesInterface.rule_lookup("1234", "test_1")
    assert add_rule == %{response: "Rule not found"}
  end


  test "Add Rule that already exists" do

    add_rule = FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{"merchant_id" => "1234", "name" => "test", "priority" => 1, "description" => "", "actions" => ["store"], "condition" => %{"ti_gt" => 4}})
    assert add_rule == %{response: "Error Rule already exists"}
  end

  test "Delete Existent Rule" do

    delete_rule = FidelityRuleEngine.Interfaces.RulesInterface.delete_rule("1234","test")
    assert delete_rule == %{response: "Deleted"}
  end




end  