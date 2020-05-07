defmodule FidelityRuleEngine.RuleLogic.Actions do
  def check_actions(list_actions) when is_list(list_actions) do
    actions_list_checked =
      Enum.map(list_actions, &FidelityRuleEngine.RuleLogic.Actions.check_actions(&1))

    # |> IO.inspect(label: "actions list checked")

    case Enum.member?(actions_list_checked, :error) do
      true -> {:error, "one of the actions is not implemented"}
      false -> {:ok, actions_list_checked}
    end
  end

  def check_actions("store") do
    fn _facts -> IO.puts("Store") end
  end

  def check_actions("issue") do
    fn _facts -> IO.puts("issue") end
  end

  def check_actions(%{"alarm" => severity}) do
    fn _facts -> IO.puts("Alarm severity: #{severity}") end
  end

  # def check_actions(%{"noevent" => name, "merchante_id" => merchante_id}) do
  #   fn facts ->
  #     FidelityRuleEngine.RuleLogic.NoEvent.callback_geo_cancel_rule(facts, merchante_id, name)
  #   end
  # end

  def check_actions(_) do
    :error
  end

  def check_actions() do
    :error
  end
end
