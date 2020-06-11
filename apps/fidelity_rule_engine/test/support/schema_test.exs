defmodule FidelityRuleEngine.SchemaTest do
  use ExUnit.Case
  use FidelityRuleEngine.RepoCase

  test "List Merchant_Id Schema" do
    rules_list = FidelityRuleEngine.Interfaces.SchemaInterfaces.schema_lookup("1234")
    assert rules_list == %{response: :notfound}
    # IO.inspect(rules_list)
  end


end
