defmodule Gqlgateway.Repo do
  use Ecto.Repo,
    otp_app: :gqlgateway,
    adapter: Ecto.Adapters.Postgres
end
