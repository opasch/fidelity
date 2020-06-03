import Mix.Config

config :fidelity_rule_engine, FidelityRuleEngine.Repo,
  username: "postgres",
  password: "postgres",
  database: "fidelity_rule_engine_test",
  hostname: "192.168.1.91",
  pool: Ecto.Adapters.SQL.Sandbox

config :fidelity_rule_engine,
  # serializer: FidelityRuleEngine.Serializer.Json,
  instance: "http://192.168.1.64/",
  fidelity_broker_normalized_queue: "fidelity_rule_engine",
  fidelity_broker_username: "guest",
  fidelity_broker_password: "guest",
  fidelity_broker_host: "192.168.1.70",
  fidelity_broker_vhost: "",
  fidelity_broker_host_port: "32771"


  config :fidelity_rule_engine, :producer_module, {Broadway.DummyProducer, []}