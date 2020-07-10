# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fidelity_app,
  ecto_repos: [FidelityApp.Repo]

# Configures the endpoint
config :fidelity_app, FidelityAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "E9qyoPyv3gtCbLDuic2/G1b4RMnqthvVt/NWPLYg/qRmm4WNfC4y3QxQPHhs2qJf",
  render_errors: [view: FidelityAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FidelityApp.PubSub,
  live_view: [signing_salt: "qH8EG34WNILzRv4IYQCt6KsihLWPMdWt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
