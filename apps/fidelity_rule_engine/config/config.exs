# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :fidelity_rule_engine,
  ecto_repos: [FidelityRuleEngine.Repo]

config :fidelity_rule_engine, FidelityRuleEngine.Repo,
  database: "fidelity_rule_engine_repo",
  username: "postgres",
  password: "postgres",
  hostname: "192.168.1.91",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
import_config "#{Mix.env()}.exs"
