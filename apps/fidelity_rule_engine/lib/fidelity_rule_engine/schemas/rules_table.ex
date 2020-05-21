defmodule FidelityRuleEngine.Schemas.RulesTables do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rules_table" do
    field(:name, :string)
    field(:actions, {:array, :string})
    field(:description, :string)
    field(:priority, :integer)
    field(:merchant_id, :string)
    field(:condition, :map)
  end

  @required_fields ~w(name actions priority merchant_id condition)
  @optional_fields ~w(description)
  @doc false
  def changeset(rule, attrs \\ %{}) do
    rule
    |> cast(attrs, @required_fields, @optional_fields)
    |> unique_constraint(:merchant_id, name: :merchant_id_index)
  end
end
