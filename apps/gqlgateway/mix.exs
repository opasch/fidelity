defmodule Gqlgateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :gqlgateway,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_path: "../../_build",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Gqlgateway.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0-rc.0", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.5"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.3"},

      # silence warn about poison
      {:poison, "~> 4.0"},

      # gql deps
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4.5"},
      {:absinthe_ecto, "~> 0.1.3"},
      {:absinthe_error_payload, "~> 1.0"},

      # auth deps
      {:guardian, "~> 2.1"},
      {:guardian_db, "~> 2.0"},
      {:comeonin, "~> 5.3"},
      {:argon2_elixir, "~> 2.3"},

      # testing web pages
      {:wallaby, "~> 0.23.0", [runtime: false, only: :test]},

      # for basic admin authorization
      {:basic_auth, "~> 2.2.2"},

      # credo for static code analysis
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
