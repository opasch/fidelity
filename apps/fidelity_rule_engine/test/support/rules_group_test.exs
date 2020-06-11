defmodule FidelityRuleEngine.RulesGroupTest do
  use ExUnit.Case
  use FidelityRuleEngine.RepoCase

  test "List all Group Rules" do
    rules_list = FidelityRuleEngine.Interfaces.RulesGroupInterface.rules_list("1234")
    assert rules_list == %{response: "No Group Rules defined in DB"}
    # IO.inspect(rules_list)
  end

  test "Add Group Rules fails, missing one rule " do
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
      FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "Group_test",
        "description" => "This is a test rule group",
        "priority" => 1,
        "rules" => ["test", "test_2"],
        "type" => "unit_rule_group"
      })

    assert add_rule == %{response: "One of the rule does not exist"}
  end

  test "Add Group Rules " do
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

    add_rule =
      FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "Group_test",
        "description" => "This is a test rule group",
        "priority" => 1,
        "rules" => ["test_1", "test_2"],
        "type" => "unit_rule_group"
      })

    assert add_rule == %{
             response: %{
               description: "This is a test rule group",
               name: "1234_Group_test",
               priority: 1,
               rules: ["test_1", "test_2"],
               type: :unit_rule_group
             }
           }
  end

  test "List Non Existent Rule" do
    add_rule =
      FidelityRuleEngine.Interfaces.RulesGroupInterface.rule_lookup("1234", "1234_Group_test")

    assert add_rule == %{response: "RuleGroup not found"}
  end

  test "Add Rule that already exists" do
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
      FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "Group_test",
        "description" => "This is a test rule group",
        "priority" => 1,
        "rules" => ["test_1", "test_2"],
        "type" => "unit_rule_group"
      })

    assert add_rule == %{response: "Error Group Rule already exists"}
  end

  # test "Delete Existent Rule" do
  #   %{response: _} =
  #     FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
  #       "merchant_id" => "1234",
  #       "name" => "test",
  #       "priority" => 1,
  #       "description" => "",
  #       "actions" => ["store"],
  #       "condition" => %{"ti_gt" => 4}
  #     })

  #   delete_rule = FidelityRuleEngine.Interfaces.RulesInterface.delete_rule("1234", "test")
  #   assert delete_rule == %{response: "Deleted"}
  # end

  test "Delete Existent Rule" do
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

    # Adding Group Rule
    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "Group_test",
        "description" => "This is a test rule group",
        "priority" => 1,
        "rules" => ["test_1", "test_2"],
        "type" => "unit_rule_group"
      })

    # FidelityRuleEngine.Interfaces.RulesGroupInterface.rule_lookup("1234", "Group_test")
    # |> IO.inspect(label: "Search Group rule")

    delete_rule =
      FidelityRuleEngine.Interfaces.RulesGroupInterface.delete_rule("1234", "Group_test")

    assert delete_rule == %{response: "Deleted"}
  end
end
