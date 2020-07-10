# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FidelityApp.Repo.insert!(%FidelityApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias FidelityApp.Repo
alias FidelityApp.Accounts.User

admin_params = %{
  # username: "Admin User 1",
  email: "admin@test.com",
  password: "supersecret@2020",
  role: "admin"
}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{}
  |> User.registration_changeset(admin_params)
  |> User.set_admin_role()
  |> IO.inspect(label: "seeds")
  |> Repo.insert!()
end
