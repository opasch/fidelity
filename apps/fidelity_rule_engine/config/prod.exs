import Config

database_url =
  System.get_env("DATABASE_URL") || "ecto://postgres:postgres@localhost/fidelity_prod"

config :fidelity_rule_engine,
  # serializer: FidelityRuleEngine.Serializer.Json,
  instance: System.get_env("BROKER_URL") || "http://localhost/",
  fidelity_broker_normalized_queue: "fidelity_rule_engine",
  fidelity_broker_username: System.get_env("BROKER_USERNAME") || "guest",
  fidelity_broker_password: System.get_env("BROKER_PASSWORD") || "guest",
  fidelity_broker_host: System.get_env("BROKER_URL") || "192.168.1.70",
  fidelity_broker_vhost: System.get_env("BROKER_VHOST") || "",
  fidelity_broker_host_port: System.get_env("BROKER_PORT") || "32771"

config :fidelity_rule_engine, FidelityRuleEngine.Repo,
  url: database_url,
  show_sensitive_data_on_connection_error: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
