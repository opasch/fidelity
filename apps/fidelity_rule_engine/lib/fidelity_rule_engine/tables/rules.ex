defmodule FidelityRuleEngine.Tables.Rules do
  @moduledoc """
  Rules Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.RulesTables
  require Logger
  import Ecto.Changeset

  # @required_fields ~w(name actions priority merchant_id condition)
  # @optional_fields ~w(description)

  def check_rules(list_rules) when is_list(list_rules) do
    rules_list_checked =
      Enum.map(list_rules, &FidelityRuleEngine.Tables.Rules.lookup(&1))
      |> IO.inspect()

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
    case Repo.get_by(RulesTables, name: name) do
      nil ->
        :notfound

      rule ->
        {:ok, Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id)}
    end
  end

  def lookup!(name) do
    case Repo.get_by(RulesTables, merchant_id: name) do
      nil ->
        nil

      rule ->
        Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id)
    end
  end

  def add(rule) do
    # TODO: pass the merchant_id within the map to avoid the merge
    struct(RulesTables, rule)
    |> changeset(%{})
  end

  def changeset(struc, attrs \\ %{}) do
    struc
    |> cast(%{}, [:actions, :condition, :name, :merchant_id, :priority])
    # |> change(name: :merchant_id)
    |> unique_constraint(:name)
    |> Repo.insert()
    |> case do
          {:ok, rule} -> 
            Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id)
      {:error, _} -> "Error Rule already exists"
    end
  end

  def delete(name) do
    case Repo.get_by(RulesTables, name: name) do
      nil ->
        :error

      rule ->
        Repo.delete(rule) 
        |> case do
          {:ok, rule} -> 
            :ok
            # Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id)
          {:error, _} -> 
            :error
        end
        
    end    
  end

  def list do
    RulesTables 
    |> Repo.all()
    |> case do
      rule -> 
            Enum.map(rule, fn x -> Map.delete(x, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) end)
      [] -> "No Rules defined in DB"
    end
  end
end
