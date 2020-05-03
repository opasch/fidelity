defmodule FidelityRuleEngine.Tables.Rules do
  use GenServer
  use RulesEngine
  require Logger

  ## Client

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def check_rules(list_rules) when is_list(list_rules) do
    rules_list_checked = Enum.map(list_rules, &FidelityRuleEngine.Tables.Rules.lookup(&1))

    case Enum.member?(rules_list_checked, :notfound) do
      true -> {:error, "One of the rule does not exist"}
      false -> {:ok, rules_list_checked}
    end
  end

  def check_rules() do
    {:error, "Please define a list of rules"}
  end

  @doc """
  Looks up the bucket `name` stored in `FidelityRuleEngine.Tables.Rules`.

  Returns `{:ok, "value"}` if the bucket exists, `:error` otherwise.
  """
  def lookup(name) do
    # 2. Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(__MODULE__, name) do
      # [{^name, msg}] -> msg 
      [{^name, msg}] -> {:ok, msg}
      [] -> :notfound
    end
  end

  def lookup!(name) do
    # 2. Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(__MODULE__, name) do
      # [{^name, msg}] -> msg 
      [{^name, msg}] -> msg
      [] -> nil
    end
  end

  def add(name, value) do
    # 3. Store to bucket `{name, value}`, call (sync) the server `:add` 
    GenServer.call(__MODULE__, {:add, {name, value}})
  end

  def delete(name) do
    # 4. Delete from bucket `name`, cast (async) the server `:add`
    GenServer.cast(__MODULE__, {:delete, name})
  end

  def list do
    # 2. tab2list is now done directly in ETS, without accessing the server
    list_found =
      :ets.tab2list(__MODULE__)
      # |> Enum.into(%{})
      |> Enum.map(fn {_k, v} -> v end)

    # |> Jason.encode!()

    list_found
  end

  ## Server
  def init(_) do
    Logger.info("Initializing Rules Table")

    table_name =
      PersistentEts.new(
        __MODULE__,
        Application.app_dir(:fidelity_rule_engine, "priv/fidelity_rules_table.tab"),
        [
          :named_table
        ]
      )

    {:ok, table_name}
  end

  def handle_call({:add, {name, value}}, _from, __MODULE__) do
    :ets.insert(__MODULE__, {name, value})

    {:reply, :ok, __MODULE__}

    # end
  end

  def handle_cast({:delete, name}, __MODULE__) do
    # 6. Read and write to the ETS table
    # IO.inspect name
    case lookup(name) do
      {:ok, _value} ->
        :ets.delete(__MODULE__, name)
        {:noreply, __MODULE__}

      :error ->
        {:noreply, __MODULE__}

      :notfound ->
        {:noreply, __MODULE__}
    end
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
