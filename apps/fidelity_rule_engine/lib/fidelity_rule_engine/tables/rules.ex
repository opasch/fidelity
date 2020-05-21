defmodule FidelityRuleEngine.Tables.Rules do
  @moduledoc """
  Rules Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.RulesTables
  require Logger

  ## Client

  def check_rules(list_rules) when is_list(list_rules) do
    rules_list_checked = Enum.map(list_rules, &FidelityRuleEngine.Tables.Rules.lookup(&1))
    |> IO.inspect
    case Enum.member?(rules_list_checked, :notfound) do
      true -> {:error, "One of the rule does not exist"}
      false -> {:ok, rules_list_checked}
    end
  end

  def check_rules() do
    {:error, "Please define a list of rules"}
  end

  @doc """
  Function to lookup for specific rule from Database

  Returns `{:ok, "value"}` if the rule exists, `:error` otherwise.
  """
  def lookup(name) do
    case Repo.get_by(RulesTables, merchant_id: name) do
      nil ->
        :notfound

      rule ->
        {:ok, Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id)}
    end
  end

  def lookup!(name) do
    case Repo.get_by(RulesTables, merchant_id: name) do
      nil ->
        nil

      rule ->
        Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id)
    end
  end

  def add(name, value) do
    # TODO: pass the merchant_id within the map to avoid the merge
    struct(RulesTables, Map.merge(value, %{merchant_id: name}))
    |> Repo.insert!()
  end

  # def delete(name) do
  #   # 4. Delete from bucket `name`, cast (async) the server `:add`
  #   GenServer.cast(__MODULE__, {:delete, name})
  # end

  def list do
    RulesTables|> Repo.all
  end
end
