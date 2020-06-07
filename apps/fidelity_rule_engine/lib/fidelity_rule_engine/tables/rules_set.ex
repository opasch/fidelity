defmodule FidelityRuleEngine.Tables.RulesSet do
  @moduledoc """
  Rules Set Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.RulesSetTable
  require Logger
  import Ecto.Changeset
  import Ecto.Query

  @doc """
  Function to lookup for specific rule from Database

  Returns `{:ok, "value"}` if the rule exists, `:error` otherwise.
  """
  def lookup(merchant_id) do
    case Repo.get_by(RulesSetTable, merchant_id: merchant_id) do
      nil ->
        :notfound

      rule ->
        # Note the manipulation of the Rule name.
        {:ok,
         Map.delete(rule, :__struct__)
         |> Map.delete(:__meta__)
         |> Map.delete(:merchant_id)
         |> Map.delete(:id)
         |> Map.delete(:inserted_at)
         |> Map.delete(:updated_at)}
    end
  end

  def lookup!(merchant_id) do
    case Repo.get_by(RulesSetTable, merchant_id: merchant_id) do
      nil ->
        nil

      rule ->
        # Note the manipulation of the Rule name.
        %{rules: found_rules} =
         Map.delete(rule, :__struct__)
         |> Map.delete(:__meta__)
         |> Map.delete(:merchant_id)
         |> Map.delete(:id)
         |> Map.delete(:inserted_at)
         |> Map.delete(:updated_at)
        
        found_rules
    end
  end



  # def lookup!(merchant_id) do
  #   query = from(RulesSetTable, where: [merchant_id: ^merchant_id], select: [:rules])

  #   # RulesTables 
  #   Repo.all(query)
  #   |> case do
  #     [] ->
  #       "No Rules defined in DB"

  #     rule ->
  #       rule

  #       # Enum.map(rule, fn x -> Map.delete(x, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id) |> Map.delete(:inserted_at) |> Map.delete(:updated_at) end)
  #   end
  # end

  def add(%{
        merchant_id: merchant_id,
        rules: rules
      } = rule_set) do

    case Repo.get_by(RulesSetTable, merchant_id: merchant_id) do
      nil -> 
        struct(RulesSetTable, rule_set)
        |> IO.inspect(label: "before changeset") 
        |> changeset(%{})
        |> Repo.insert()
        |> case do
          {:ok, rule} ->
            Map.delete(rule, :__struct__)
            |> Map.delete(:__meta__)
            |> Map.delete(:merchant_id)
            |> Map.delete(:id)
            |> Map.delete(:inserted_at)
            |> Map.delete(:updated_at)
          {:error, _} ->
            "Error Rule already exists"
        end
      rule_set_list -> 
        rule_set_list
        |> changeset(%{rules: rule_set_list.rules ++ rules   |> Enum.uniq})
        |> Repo.update()
        |> case do
          {:ok, rule} ->
            Map.delete(rule, :__struct__)
            |> Map.delete(:__meta__)
            |> Map.delete(:merchant_id)
            |> Map.delete(:id)
            |> Map.delete(:inserted_at)
            |> Map.delete(:updated_at)
          {:error, _} ->
            "Error Rule already exists"
        end
    end
  end

  def remove(%{
        merchant_id: merchant_id,
        rules: rules
      } = rule_set) do

    case Repo.get_by(RulesSetTable, merchant_id: merchant_id) do
      nil -> 
        :error 
      rule_set_list -> 
        rule_set_list
        |> changeset(%{rules: rule_set_list.rules ++ rules   |> Enum.uniq})
        |> Repo.update()
        |> case do
        {:ok, rule} ->
          Map.delete(rule, :__struct__)
          |> Map.delete(:__meta__)
          |> Map.delete(:merchant_id)
          |> Map.delete(:id)
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)
        {:error, _} ->
          "Error Rule already exists"
      end
    end
  end


  def changeset(struc, attrs \\ %{}) do
    struc
    |> cast(attrs, [:merchant_id, :rules])
    |> unique_constraint(:merchant_id)
  end



  def delete(merchant_id) do
    case Repo.get_by(RulesSetTable, merchant_id: merchant_id) do
      nil ->
        :error

      rule ->
        Repo.delete(rule)
        |> case do
          {:ok, _rule} ->
            :ok

          # Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id)
          {:error, _} ->
            :error
        end
    end
  end

  def list(merchant_id) do
    # query = "select * from rules_table where merchant_id=#{merchant_id}"
    # query = from u in "rules_table",
    #       where: u.merchant_id == ^merchant_id,
    #       select: u.*

    query = from(RulesSetTable, where: [merchant_id: ^merchant_id], select: [:rules])

    # RulesTables 
    Repo.all(query)
    |> case do
      [] ->
        "No Rules defined in DB"

      rule ->
        Enum.map(rule, fn x ->
          Map.delete(x, :__struct__)
          |> Map.delete(:__meta__)
          |> Map.delete(:merchant_id)
          |> Map.delete(:id)
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)
        end)
    end
  end
end
