use Mix.Config

# Configure your database
config :gqlgateway, Gqlgateway.Repo,
  username: "postgres",
  password: "postgres",
  database: "gqlgateway_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
