defmodule FidelityRuleEngine.Repo.Migrations.SchemaTable do
  use Ecto.Migration
  
  def change do
    create table("schema_table") do
      add :merchant_id, :string
      add :schema, :map
      
      timestamps()
    end

    create unique_index(:schema_table, [:merchant_id])
  end
end
