defmodule FidelityRuleEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :fidelity_rule_engine,
      version: "0.1.0",
      build_path: "../../_build",
      # config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FidelityRuleEngine.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      # {:rules_engine, path: "../rules_engine"},
      {:rules_engine, in_umbrella: true},
      {:broadway_rabbitmq, "~> 0.6.0"},
      {:jason, "~> 1.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:persistent_ets, "~> 0.2.0"},
      {:ex_json_schema, "~> 0.7.0"},
      {:credo, "~> 1.3.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21.0", only: :dev},
      {:excoveralls, "~> 0.12.0", only: :test},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false}
      # {:telemetry, "~> 0.4.1"},
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/rabbitmq"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [ 
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

end
