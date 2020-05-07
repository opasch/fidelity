defmodule FidelityRuleEngine.RuleLogic.TotalPrice do
  def greater_than_rule(facts, total_price) do
    # IO.puts("Greater_than_zero_rule (#{inspect(Map.get(facts, :v))})\n")

    case Map.get(facts, "total_price") do
      nil ->
        false

      x when x >= total_price ->
        true

      _ ->
        false
    end
  end

  def less_than_rule(facts, total_price) do
    # IO.puts("Greater_than_zero_rule (#{inspect(Map.get(facts, :v))})\n")

    case Map.get(facts, "total_price") do
      nil -> false
      x when x <= total_price -> true
      _ -> false
    end
  end

  def strict_equal_than_rule(facts, total_price) do
    # IO.puts("Greater_than_zero_rule (#{inspect(Map.get(facts, :v))})\n")

    case Map.get(facts, "total_price") do
      nil -> false
      x when x === total_price -> true
      _ -> false
    end
  end
end
