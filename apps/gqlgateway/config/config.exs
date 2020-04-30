# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gqlgateway,
  ecto_repos: [Gqlgateway.Repo]

config :gqlgateway, Gqlgateway.Accounts.Guardian,
  issuer: "gqlgateway",
  secret_key: "b4Kw55rcFSWYqExT469SJ9gB1TRW7ul0X4RnTVBAE3ulxAvBUNamirx53xUhIAtS"

config :guardian, Guardian.DB,
  repo: Gqlgateway.Repo, # Add your repository module
  schema_name: "guardian_tokens", # default
  sweep_interval: 60 # default: 60 minutes

# Configures the endpoint
config :gqlgateway, GqlgatewayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nfZzo+JLkx3uER1beZmlRiUdcpM2YAbmejNmYkqfq02hCJupBy9lxP+XWYxnDskk",
  render_errors: [view: GqlgatewayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Gqlgateway.PubSub,
  live_view: [signing_salt: "i0Qu2cyJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
