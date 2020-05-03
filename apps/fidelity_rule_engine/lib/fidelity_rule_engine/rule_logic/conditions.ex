defmodule FidelityRuleEngine.RuleLogic.Conditions do
  def check_conditions(%{"ti_gt" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalItems.greater_than_rule(&1, value)}
  end

  def check_conditions(%{"ti_lt" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalItems.less_than_rule(&1, value)}
  end

  def check_conditions(%{"ti_eq" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalItems.strict_equal_than_rule(&1, value)}
  end

  def check_conditions(%{"tp_gt" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalPrice.greater_than_rule(&1, value)}
  end

  def check_conditions(%{"tp_lt" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalPrice.less_than_rule(&1, value)}
  end

  def check_conditions(%{"tp_eq" => value}) do
    {:ok, &FidelityRuleEngine.RuleLogic.TotalPrice.strict_equal_than_rule(&1, value)}
  end

  def check_conditions(%{"client_address" => client_address}) do
    {:ok, &FidelityRuleEngine.RuleLogic.ClientAddress.equal_rule(&1, client_address)}
  end

  # def check_conditions(%{"in" => value}) do
  #   # IO.inspect value, label: "GEO IN Conditions"
  #   {:ok, &FidelityRuleEngine.RuleLogic.Geo.within_area(&1, value)}
  # end

  # def check_conditions(%{"time_gt" => value}) do
  #   {:ok, &FidelityRuleEngine.RuleLogic.Time.greater_than_rule(&1, value)}
  # end

  # def check_conditions(%{
  #       "task_name" => task_name,
  #       "device_id" => device_id,
  #       "eta" => eta_value
  #     }) do
  #   {:ok, &FidelityRuleEngine.RuleLogic.NoEvent.rule(&1, {task_name, device_id, eta_value})}
  # end

  def check_conditions(_) do
    {:error, "no condition defined"}
  end

  def check_conditions() do
    {:error, "no condition defined"}
  end
end
