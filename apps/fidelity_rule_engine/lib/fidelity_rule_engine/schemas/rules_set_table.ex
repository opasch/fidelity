defmodule FidelityRuleEngine.Schemas.RulesSetTable do
  use Ecto.Schema
  # import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "rules_set_table" do
    field(:merchant_id, :string)
    field(:rules, {:array, :string})

    timestamps(@timestamps_opts)
  end
end
