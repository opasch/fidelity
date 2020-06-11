defmodule FidelityRuleEngine.RulesFireTest do
  use ExUnit.Case
  use FidelityRuleEngine.RepoCase

  test "Add Rules Set " do
    payload_dec = %{
      "cart_id" => "9roj8f70TUEU",
      "client_address" => "0xab96032f5a7Efe3F95622c5B9D98D50F96a91756",
      "items" => [
        %{
          "product_id" => "1",
          "product_name" => "product_1",
          "product_price" => "5.00"
        },
        %{
          "product_id" => "2",
          "product_name" => "product_2",
          "product_price" => "5.00"
        },
        %{
          "product_id" => "3",
          "product_name" => "product_3",
          "product_price" => "5.00"
        }
      ],
      "merchant_id" => "1234",
      "total_items" => 3,
      "total_price" => "15.00"
    }

    # Adding One Rule
    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "test_1",
        "priority" => 1,
        "description" => "",
        "actions" => ["store"],
        # "condition" => %{"ti_gt" => 4}
        "condition" => %{"key" => "total_items", "Operation" => "gt", "value" => 4}
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

    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{
        "merchant_id" => "1234",
        "rules" => ["test_1", "Group_test"]
      })

    assert FidelityRuleEngine.RuleEngines.Engine.main(payload_dec) == [nil, nil]

    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{
        "merchant_id" => "1234",
        "name" => "test_3",
        "priority" => 1,
        "description" => "",
        "actions" => ["store"],
        "condition" => %{"key" => "total_items", "Operation" => "gt", "value" => 3}
      })

    %{response: _} =
      FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{
        "merchant_id" => "1234",
        "rules" => ["test_3"]
      })

    IO.inspect(label: "Fire Rule")

    assert FidelityRuleEngine.RuleEngines.Engine.main(payload_dec) == [
             nil,
             nil,
             {"test_3", [:ok]}
           ]
  end
end
