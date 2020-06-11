defmodule FidelityRuleEngine.Repo.Migrations.RulesTable do
  use Ecto.Migration
  # @timestamps_opts [type: :utc_datetime, usec: true]
  @timestamps_opts [type: :utc_datetime, usec: Mix.env != :test]

  def change do
    create table("rules_table") do
      add :name, :string
      add :actions, {:array, :string}
      add :description, :string
      add :priority, :integer
      add :merchant_id, :string
      add :condition, :map

      timestamps()
      # timestamps @timestamps_opts
    end

    create unique_index(:rules_table, [:name])
  end
end
