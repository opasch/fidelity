defmodule Gqlgateway.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :roles, {:array, :string}, default: ["customer"]

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

  end
end
