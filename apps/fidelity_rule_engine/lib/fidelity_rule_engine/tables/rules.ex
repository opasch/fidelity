defmodule FidelityRuleEngine.Tables.Rules do
  @moduledoc """
  Rules Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.RulesTable
  require Logger
  import Ecto.Changeset
  import Ecto.Query

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
  def lookup(merchant_id, name) do
    case Repo.get_by(RulesTable, name: merchant_id <> "_" <> name) do
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
    case Repo.get_by(RulesTable, name: merchant_id <> "_" <> name) do
      nil ->
        nil

      rule ->
        # Note the manipulation of the Rule name.
        Map.delete(rule, :__struct__)
         |> Map.delete(:__meta__)
         |> Map.delete(:merchant_id)
         |> Map.delete(:id)
         |> Map.put(:name, name)
         |> Map.delete(:inserted_at)
         |> Map.delete(:updated_at)
    end
  end


  # def lookup!(merchant_id, name) do
  #   full_name = merchant_id <> "_" <> name

  #   query =
  #     from(RulesTable,
  #       where: [merchant_id: ^merchant_id, name: ^full_name],
  #       select: [:actions, :condition, :description, :name, :priority]
  #     )

  #   # RulesTable 
  #   Repo.all(query)
  #   |> case do
  #     [] ->
  #       "No Rules defined in DB"

  #     rule ->
  #       rule

  #       # Enum.map(rule, fn x -> Map.delete(x, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id) |> Map.delete(:inserted_at) |> Map.delete(:updated_at) end)
  #   end

    # case Repo.get_by(RulesTable, name: merchant_id <> "_" <> name) do
    #   nil ->
    #     nil

    #   rule ->
    #     Map.delete(rule, :__struct__) |> Map.delete(:__meta__) |> Map.delete(:merchant_id) |> Map.delete(:id) |> Map.put(:name, name)
    # end
  # end

  @doc """
  Function to lookup for specific rule from Database

  Returns `{:ok, "value"}` if the rule exists, `:error` otherwise.
  """
  def lookup(name) do
    case Repo.get_by(RulesTable, name: name) do
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




  def add(rule) do
    struct(RulesTable, rule)
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
        Map.delete(rule, :__struct__)
        |> Map.delete(:__meta__)
        |> Map.delete(:merchant_id)
        |> Map.delete(:id)

      {:error, _} ->
        "Error Rule already exists"
    end
  end

  def delete(merchant_id, name) do
    case Repo.get_by(RulesTable, name: merchant_id <> "_" <> name) do
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

    query =
      from(RulesTable,
        where: [merchant_id: ^merchant_id],
        select: [:actions, :condition, :description, :name, :priority]
      )

    # RulesTable 
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
        end)
    end
  end
end
