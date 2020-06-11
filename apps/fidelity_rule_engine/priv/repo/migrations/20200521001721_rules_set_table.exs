defmodule FidelityRuleEngine.Repo.Migrations.RulesSetTable do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime, usec: true]

  def change do
    create table("rules_set_table") do
      add :merchant_id, :string
      add :rules, {:array, :string}
      
      timestamps @timestamps_opts
    end

    create unique_index(:rules_set_table, [:merchant_id])
  end
end
