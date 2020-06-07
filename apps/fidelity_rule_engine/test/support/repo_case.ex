defmodule FidelityRuleEngine.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias FidelityRuleEngine.Repo

      import Ecto
      import Ecto.Query
      import FidelityRuleEngine.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FidelityRuleEngine.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(FidelityRuleEngine.Repo, {:shared, self()})
    end

    :ok
  end
end
