defmodule Fidelity.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      elixir: "~> 1.9",
      deps: deps(),
      releases: [
        testing: [
	  include_executables_for: [:unix],
          applications: [
	    gqlgateway: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
  []
  end
end
