import Config

config :fidelity_rule_engine,
  # serializer: FidelityRuleEngine.Serializer.Json,
  instance: "http://192.168.1.64/",
  fidelity_broker_normalized_queue: "fidelity_rule_engine",
  fidelity_broker_username: "guest",
  fidelity_broker_password: "guest",
  fidelity_broker_host: "192.168.1.70",
  fidelity_broker_vhost: "",
  fidelity_broker_host_port: "32771"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
