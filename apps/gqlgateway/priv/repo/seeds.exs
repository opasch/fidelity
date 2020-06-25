# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gqlgateway.Repo.insert!(%Gqlgateway.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds.exs
alias Gqlgateway.Repo
alias Gqlgateway.Accounts.User

admin_params = %{
  username: "Admin User 3",
  email: "admin_2@test.com",
  password: "supersecret",
  password_confirmation: "supersecret",
  role: "admin"
}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{}
  |> User.changeset(admin_params)
  |> IO.inspect(label: "seeds")
  |> Repo.insert!()
end
