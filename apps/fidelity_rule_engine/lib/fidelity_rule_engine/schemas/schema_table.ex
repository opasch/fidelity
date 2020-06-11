defmodule FidelityRuleEngine.Schemas.SchemaTable do
  use Ecto.Schema
  # import Ecto.Changeset
  schema "schema_table" do
    field(:merchant_id, :string)
    field(:schema, :map)

    timestamps()
  end
end
