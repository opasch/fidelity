defmodule FidelityRuleEngine.Schemas.RulesTable do
  use Ecto.Schema
  # import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "rules_table" do
    field(:name, :string)
    field(:actions, {:array, :string})
    field(:description, :string)
    field(:priority, :integer)
    field(:merchant_id, :string)
    field(:condition, :map)

    timestamps @timestamps_opts
  end

  # @required_fields ~w(name actions priority merchant_id condition)
  # @optional_fields ~w(description)
  # @doc false
  # def changeset(rule, attrs \\ %{}) do
  #   IO.inspect rule
  #   rule
  #   |> cast(attrs, @required_fields, @optional_fields)
  #   |> unique_constraint(name: :merchant_id)
  #   |> Repo.insert()
  #   |> case do
  #     {:ok, merchant_id} -> merchant_id
  #     {:error, _} -> "Error Rule already exists"
  #   end
  # end
end
