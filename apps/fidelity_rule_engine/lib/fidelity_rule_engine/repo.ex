defmodule FidelityRuleEngine.Repo do
  use Ecto.Repo,
    otp_app: :fidelity_rule_engine,
    adapter: Ecto.Adapters.Postgres
end
