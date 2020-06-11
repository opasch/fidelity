defmodule FidelityRuleEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  # @module __MODULE__
  require Logger

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: FidelityRuleEngine.Worker.start_link(arg)
      # {FidelityRuleEngine.Worker, arg}
      # {FidelityRuleEngine.Tables.Rules, []},
      # {FidelityRuleEngine.Tables.RulesGroup, []},
      # {FidelityRuleEngine.Tables.RulesSet, []},
      {FidelityRuleEngine.Tables.Schema, []},
      {FidelityRuleEngine.Stages.MessageHandler, []},
      {FidelityRuleEngine.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FidelityRuleEngine.Supervisor]
    # :ok = Logger.info("#{@module}: Started on port #{port}")
    Supervisor.start_link(children, opts)
  end
end
