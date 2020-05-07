defmodule FidelityRuleEngine.RuleLogic.ClientAddress do
  def equal_rule(facts, client_address) do
    # IO.puts("Greater_than_zero_rule (#{inspect(Map.get(facts, :v))})\n")

    case Map.get(facts, "client_address") do
      nil -> false
      x when x == client_address -> true
      _ -> false
    end
  end
end
