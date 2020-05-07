defmodule FidelityRuleEngine.RulesHelper do
  @moduledoc """
  Rules Helper Module
  """
  # defstruct :ruleset, :rulesgroup, :rules 
  use RulesEngine
  require Logger
  alias FidelityRuleEngine.Tables.{RulesSet, Rules, RulesGroup}

  def rules_set_lookup(merchant_id) do
    case RulesSet.lookup!(merchant_id) do
      nil ->
        []

      list_result ->
        # IO.inspect list_result, label: "list_rules_set"
        list_rules =
          Enum.map(list_result, &Rules.lookup!(&1))
          |> Enum.reject(&is_nil/1)

        # |> IO.inspect(label: "list rules")

        list_group_rules =
          Enum.map(list_result, &RulesGroup.lookup!(&1))
          |> Enum.reject(&is_nil/1)

        # |> Enum.map(&(RuleGroup.create(&1)))    
        # |> IO.inspect(label: "list rules group")

        %{}
        |> Map.put(:rulesset, list_result)
        |> Map.put(:rulesgroup, list_group_rules)
        |> Map.put(:rules, list_rules)

        # |> IO.inspect(label: "list all ")
    end

    # )
    # |> IO.inspect(label: "rules list")
  end

  def check_rules(merchant_id, list_rules) when is_list(list_rules) do
    rules_list_checked =
      Enum.map(
        list_rules,
        &case Rules.lookup(merchant_id <> "_" <> &1) do
          :notfound ->
            case RulesGroup.lookup(merchant_id <> "_" <> &1) do
              :notfound ->
                "notfound_" <> &1

              _ ->
                &1
            end

          _ ->
            &1
        end
      )

    # |> IO.inspect()

    #   case Enum.member?(rules_list_checked, :notfound) do
    case Enum.find_value(rules_list_checked, false, fn x -> String.contains?(x, "notfound") end) do
      true -> {:error, "One of the rule does not exist"}
      false -> {:ok, rules_list_checked}
    end
  end

  def check_rules(_, _) do
    {:error, "Please define a list of rules"}
  end

  def check_rules() do
    {:error, "Please define a list of rules"}
  end

  def get_actual_rules(merchant_id, list_rules) when is_list(list_rules) do
    {:ok,
     Enum.map(
       list_rules,
       &case Rules.lookup(merchant_id <> "_" <> &1) do
         :notfound ->
           nil

         {:ok, rule_map} ->
           # IO.inspect rule_map, label: "rule_map"
           with {:ok, condition_checked} <-
                  FidelityRuleEngine.RuleLogic.Conditions.check_conditions(rule_map.condition),
                {:ok, actions_checked} <-
                  FidelityRuleEngine.RuleLogic.Actions.check_actions(rule_map.actions) do
             struct(Rule, %{rule_map | condition: condition_checked, actions: actions_checked})

             # |> IO.inspect
           else
             {:error, _} ->
               nil
           end
       end
     )
     |> Enum.reject(&is_nil/1)}
  end

  def get_actual_rules(_, _) do
    {:error, "Please define a list of rules"}
  end

  def get_actual_rules() do
    {:error, "Please define a list of rules"}
  end

  def get_actual_rules_group(merchant_id, list_rules_group) when is_list(list_rules_group) do
    actual_list_rules_group =
      Enum.map(
        list_rules_group,
        &case RulesGroup.lookup(merchant_id <> "_" <> &1) do
          :notfound ->
            nil

          {:ok, rule_group_map} ->
            # IO.inspect rule_group_map, label: "rule_group_map"
            {:ok, get_actual_rules_details} = get_actual_rules(merchant_id, rule_group_map.rules)

            # %{rule_group_map | rules: get_actual_rules(merchant_id, rule_group_map.rules)}
            %{rule_group_map | rules: get_actual_rules_details}
            # |> IO.inspect(label: "Rules Group")
        end
      )
      |> Enum.reject(&is_nil/1)

    # |> IO.inspect(label: "actual_list_rules_group")

    {:ok, actual_list_rules_group}
  end

  def get_actual_rules_group(_, _) do
    {:error, "Please define a list of rules"}
  end

  def get_actual_rules_group() do
    {:error, "Please define a list of rules"}
  end

  # def noevent_delete_rules(merchant_id, name) do
  #   rule_name = "noevent_rule_" <> name
  #   rule_geo_name = "noevent_geo_" <> name
  #   rule_group_name = "noevent_group_" <> name

  #   _ =
  #     Rules.delete(merchant_id <> "_" <> rule_name) 
  #     # |> IO.inspect(label: "Delete #{rule_name}")

  #   _ =
  #     Rules.delete(merchant_id <> "_" <> rule_geo_name)
  #     # |> IO.inspect(label: "Delete #{rule_geo_name}")

  #   _ =
  #     RulesGroup.delete(merchant_id <> "_" <> rule_group_name)
  #     # |> IO.inspect(label: "Delete #{rule_group_name}")

  #   _ =
  #     RulesSet.remove(merchant_id, rule_group_name)
  #     # |> IO.inspect(label: "Delete #{rule_group_name} from Rule Set")

  #   FidelityRuleEngine.Tables.TasksRegistry.cancel(merchant_id <> "_" <> rule_name)
  #   # |> IO.inspect(label: "Delete #{rule_group_name} : Cancel Task ")
  #   Logger.debug(fn -> "{\"Fidelity_Rules_Engine\":\"NoEvent_#{name} Deleted\"}" end)

  # end

  # def noevent_lookup_rules(merchant_id, name) do
  #   rule_name = "noevent_rule_" <> name
  #   rule_geo_name = "noevent_geo_" <> name
  #   rule_group_name = "noevent_group_" <> name

  #   list_rules = [
  #     rule_geo_name,
  #     rule_name,
  #     rule_group_name
  #   ]

  #   with {:ok, noevent_rules} <-
  #          FidelityRuleEngine.RulesHelper.get_actual_rules(merchant_id, list_rules) do
  #     noevent_rules
  #   else
  #     _ ->
  #       "Rules not found"
  #   end
  # end
end
