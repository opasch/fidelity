defmodule FidelityApp.Repo do
  use Ecto.Repo,
    otp_app: :fidelity_app,
    adapter: Ecto.Adapters.Postgres
end
