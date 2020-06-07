defmodule FidelityRuleEngine.Tables.RulesGroup do
  @moduledoc """
  Rules Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.RulesGroupTable
  require Logger
  import Ecto.Changeset
  import Ecto.Query

  @doc """
  Function to lookup for specific rule from Database

  Returns `{:ok, "value"}` if the rule exists, `:error` otherwise.
  """
  def lookup(merchant_id, name) do
    case Repo.get_by(RulesGroupTable, name: merchant_id <> "_" <> name) do
      nil ->
        :notfound

      rule ->
        # Note the manipulation of the Rule name.
        {:ok,
         Map.delete(rule, :__struct__)
         |> Map.delete(:__meta__)
         |> Map.delete(:merchant_id)
         |> Map.delete(:id)
         |> Map.put(:name, name)
         |> Map.delete(:inserted_at)
         |> Map.delete(:updated_at)}
    end
  end

  def lookup!(merchant_id, name) do
    case Repo.get_by(RulesGroupTable, name: merchant_id <> "_" <> name) do
      nil ->
        nil

      rule ->
        Map.delete(rule, :__struct__)
        |> Map.delete(:__meta__)
        |> Map.delete(:merchant_id)
        |> Map.delete(:id)
        |> Map.put(:name, name)
        |> Map.delete(:inserted_at)
        |> Map.delete(:updated_at)
    end
  end

  def add(rule_group) do
    struct(RulesGroupTable, rule_group)
    |> changeset(%{})
  end

  def changeset(struc, attrs \\ %{}) do
    struc
    |> cast(%{}, [:type, :rules, :name, :merchant_id, :priority])
    # |> change(name: :merchant_id)
    |> unique_constraint(:name)
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
  end

  def delete(merchant_id, name) do
    case Repo.get_by(RulesGroupTable, name: merchant_id <> "_" <> name) do
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
    # query = "select * from rules_group_table where merchant_id=#{merchant_id}"
    # Create a query
    # query = from u in "rules_group_table",
    #           where: u.merchant_id == ^merchant_id,
    #           select: u.*

    query =
      from(RulesGroupTable,
        where: [merchant_id: ^merchant_id],
        select: [:description, :name, :priority, :type, :rules]
      )

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
