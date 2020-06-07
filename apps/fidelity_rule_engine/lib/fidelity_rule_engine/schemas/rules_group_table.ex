defmodule FidelityRuleEngine.Schemas.RulesGroupTable do
  use Ecto.Schema
  # import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "rules_group_table" do
    field(:name, :string)
    field(:rules, {:array, :string})
    field(:description, :string)
    field(:priority, :integer)
    field(:merchant_id, :string)
    field(:type, FidelityRuleEngine.Schemas.AtomType)

    timestamps(@timestamps_opts)
  end
end
