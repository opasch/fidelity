defmodule FidelityRuleEngine.Interfaces.RulesSetInterfaces do
  @moduledoc """
  Controller to handle endpoint routes
  """
  require Logger

  @module __MODULE__

  # alias FidelityRuleEngine.Serializer
  alias FidelityRuleEngine.Tables.RulesSet
  alias FidelityRuleEngine.Utils

  # @doc """
  # Get Templates from Mapping

  # Returns : json response

  # """
  # def rules_list(merchant_id) do
  #   Utils.render(RulesSet.list(merchant_id))
  # end

  # @spec rule_lookup(String.t()) :: Map.t()
  # def rule_lookup(merchant_id) do
  #   case RulesSet.lookup(merchant_id) do
  #     {:ok, msg} ->
  #       Utils.render(msg)

  #     :notfound ->
  #       Utils.render("No Rule Set found")
  #   end
  # end

  @doc """
  Get Templates from Mapping

  Returns : json response

  """
  @spec rules_set_lookup(String.t()) :: Map.t()
  def rules_set_lookup(merchant_id) do
    # TODO: add detailed error message handling later
    rule_set_lookup_result = FidelityRuleEngine.RulesHelper.rules_set_lookup(merchant_id)
    Utils.render(rule_set_lookup_result)
  end

  @doc """
  Add rule set to db

  Returns : json response

  """
  @spec add_rule(Map.t()) :: Map.t()
  def add_rule(%{
        "merchant_id" => merchant_id,
        "rules" => rules
      }) do
    with {:ok, _rules_checked} <-
           FidelityRuleEngine.RulesHelper.check_rules(merchant_id, rules) do
      rule_set = %{
        merchant_id: merchant_id,
        rules: rules
      }

      Utils.render(RulesSet.add(rule_set))
    else
      {:error, reason} ->
        Utils.render(reason)
    end
  end

  def add_rule(_) do
    Logger.info("#{@module}: Wrong Payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"merchant_id\" => merchant_id,\"rules\" => rules}"
    )
  end

  @spec delete_rule(Map.t()) :: Map.t()
  def delete_rule(%{
        "merchant_id" => merchant_id,
        "rules" => rules
      }) do
    with {:ok, _rules_checked} <-
           FidelityRuleEngine.RulesHelper.check_rules(merchant_id, rules) do
      rule_set = %{
        merchant_id: merchant_id,
        rules: rules
      }

      Utils.render(RulesSet.remove(rule_set))
    else
      {:error, reason} ->
        Utils.render(reason)
    end
  end

  @spec delete_rule(Map.t()) :: Map.t()
  def delete_rule(%{
        "merchant_id" => merchant_id
      }) do
    # with {:ok, _rules_checked} <-
    #        FidelityRuleEngine.RulesHelper.check_rules(merchant_id, rules) do

      Utils.render(RulesSet.delete(merchant_id))
    # else
    #   {:error, reason} ->
    #     Utils.render(reason)
    # end
  end

  def delete_rule(_) do
    Logger.info("#{@module}: Wrong Payload format received")

    Utils.render(
      "Oops, Wrong payload Format, It should be {\"merchant_id\" => merchant_id,\"rules\" => rules}"
    )
  end


end
