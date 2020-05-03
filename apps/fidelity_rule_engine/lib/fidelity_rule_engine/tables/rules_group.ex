defmodule FidelityRuleEngine.Tables.RulesGroup do
  use GenServer
  require Logger

  ## Client

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Looks up the bucket `name` stored in `FidelityRuleEngine.Tables.RulesGroup`.

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

  # def add(%{name: name, type: type, rules: rules, priority: priority, description: description}) do
  def add(name, value) do
    # 3. Store to bucket `{name, value}`, cast (async) the server `:add` 
    # value = 
    # %{
    #   name: name,
    #   priority: priority,
    #   type: type,
    #   rules: Enum.map(rules, fn x -> FidelityRuleEngine.Tables.Rules.lookup!(x) end) |> Enum.reject(&is_nil/1)
    # }
    GenServer.cast(__MODULE__, {:add, {name, value}})
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
    Logger.info("Initializing RulesGroup Table")

    table_name =
      PersistentEts.new(
        __MODULE__,
        Application.app_dir(:fidelity_rule_engine, "priv/fidelity_rules_group_table.tab"),
        [
          :named_table
        ]
      )

    {:ok, table_name}
  end

  def handle_cast({:add, {name, value}}, __MODULE__) do
    # 5. Read and write to the ETS table
    # IO.inspect name
    case lookup(name) do
      {:ok, _value} ->
        {:noreply, __MODULE__}

      :notfound ->
        :ets.insert(__MODULE__, {name, value})
        {:noreply, __MODULE__}
    end
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
