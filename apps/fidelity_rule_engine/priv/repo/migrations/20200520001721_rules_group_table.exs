defmodule FidelityRuleEngine.Repo.Migrations.RulesGroupTable do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime, usec: true]

  def change do
    create table("rules_group_table") do
      add :name, :string
      add :rules, {:array, :string}
      add :description, :string
      add :priority, :integer
      add :merchant_id, :string
      add :type, :string

      timestamps @timestamps_opts
    end

    create unique_index(:rules_group_table, [:name])
  end
end
