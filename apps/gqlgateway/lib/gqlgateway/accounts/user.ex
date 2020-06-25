defmodule Gqlgateway.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2}

  import Ecto.Changeset

  alias Argon2

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
  @roles ~w(customer merchant)

  schema "users" do
    pow_user_fields()
    # field :email, :string
    # field :password, :string, virtual: true
    # field :password_hash, :string
    field :wallet, :string
    field :role, :string, default: "customer"

    timestamps()
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ~w(customer merchant admin))
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ~w(customer merchant admin))

    # |> cast(attrs, [:email, :username, :password, :roles])
    # |> cast(attrs, [:username, :roles])
    # |> validate_required([:email, :username, :password, :roles])
    # |> validate_required([ :username, :roles])
    # |> validate_length(:password, min: 8)
    # |> validate_format(:email, @email_regex)
    # |> unique_constraint(:email, downcase: true)
    # |> unique_constraint(:username, downcase: true)

    # |> validate_inclusion_each(:roles, @roles)
    # |> put_password_hash()
  end

  # defp validate_inclusion_each(changeset, field, set) when is_atom(field) do
  #   validate_change(changeset, field, fn (_, values) ->
  #       case Enum.all?(values, fn x -> x in set end) do
  #         false -> [{field, "is invalid"}]
  #         _ -> []
  #       end
  #     end)
  # end

  # defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  #   change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  # end

  # defp put_password_hash(changeset), do: changeset
end
