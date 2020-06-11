defmodule FidelityRuleEngine.Tables.Schema do
  @moduledoc """
  Rules Set Table Repo Helper.

  """
  alias FidelityRuleEngine.Repo
  alias FidelityRuleEngine.Schemas.SchemaTable
  require Logger
  import Ecto.Changeset
  import Ecto.Query

  @doc """
  Function to lookup for specific rule from Database

  Returns `{:ok, "value"}` if the rule exists, `:error` otherwise.
  """
  def lookup(merchant_id) do
    case Repo.get_by(SchemaTable, merchant_id: merchant_id) do
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
    case Repo.get_by(SchemaTable, merchant_id: merchant_id) do
      nil ->
        nil

      found_schema ->
        # Note the manipulation of the Rule name.
        %{schema: found_schema} =
          Map.delete(found_schema, :__struct__)
          |> Map.delete(:__meta__)
          |> Map.delete(:merchant_id)
          |> Map.delete(:id)
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)

        found_schema
    end
  end


  def add(
        %{
          merchant_id: merchant_id,
          schema: schema
        } = merchant_schema
      ) do
    case Repo.get_by(SchemaTable, merchant_id: merchant_id) do
      nil ->
        struct(SchemaTable, merchant_schema)
        |> changeset(%{})
        |> Repo.insert()
        |> case do
          {:ok, stored_schema} ->
            Map.delete(stored_schema, :__struct__)
            |> Map.delete(:__meta__)
            |> Map.delete(:merchant_id)
            |> Map.delete(:id)
            |> Map.delete(:inserted_at)
            |> Map.delete(:updated_at)

          {:error, _} ->
            "Error Schema already exists"
        end

      stored_schema ->
        stored_schema
        |> changeset(%{schema: schema})
        |> Repo.update()
        |> case do
          {:ok, stored_schema} ->
            Map.delete(stored_schema, :__struct__)
            |> Map.delete(:__meta__)
            |> Map.delete(:merchant_id)
            |> Map.delete(:id)
            |> Map.delete(:inserted_at)
            |> Map.delete(:updated_at)

          {:error, _} ->
            "Error Schema already exists"
        end
    end
  end

  def changeset(struc, attrs \\ %{}) do
    struc
    |> cast(attrs, [:merchant_id, :schema])
    |> unique_constraint(:merchant_id)
  end

  def delete(merchant_id) do
    case Repo.get_by(SchemaTable, merchant_id: merchant_id) do
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

    query = from(SchemaTable, where: [merchant_id: ^merchant_id], select: [:schema])

    # RulesTables 
    Repo.all(query)
    |> case do
      [] ->
        "No schema defined in DB"

      schema ->
        Enum.map(schema, fn x ->
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
