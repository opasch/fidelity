defmodule FidelityRuleEngine.Tables.RulesSet do
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
  Looks up the bucket `name` stored in `FidelityRuleEngine.Tables.RulesSet`.

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

  def add(name, value) when is_list(value) do
    # 3. Store to bucket `{name, value}`, call (sync) the server `:add` 
    GenServer.call(__MODULE__, {:add, {name, value}})
  end

  def add(_name, _value) do
    # 3. Store to bucket `{name, value}`, call (sync) the server `:add` 
    {:error, "Not valid"}
  end

  def remove(name, value) when is_binary(value) do
    # 4. Delete from bucket `name`, cast (async) the server `:add`
    GenServer.call(__MODULE__, {:remove, {name, [value]}})
  end

  def remove(_name, _value) do
    # 4. Delete from bucket `name`, cast (async) the server `:add`
    {:error, "Not valid"}
  end

  def delete(name) do
    # 4. Delete from bucket `name`, cast (async) the server `:add`
    GenServer.call(__MODULE__, {:delete, name})
  end

  def list do
    # 2. tab2list is now done directly in ETS, without accessing the server
    list_found =
      :ets.tab2list(__MODULE__)
      |> Enum.into(%{})

    # |> Enum.map( fn {_k, v} ->  v end)

    # |> Jason.encode!()

    list_found
  end

  ## Server
  def init(_) do
    Logger.info("Initializing Rule Set Table")

    table_name =
      PersistentEts.new(
        __MODULE__,
        Application.app_dir(:fidelity_rule_engine, "priv/fidelity_rules_set_table.tab"),
        [
          :named_table
        ]
      )

    {:ok, table_name}
  end

  def handle_call({:add, {name, value}}, _from, __MODULE__) do
    # 5. Read and write to the ETS table
    # IO.inspect name
    case lookup(name) do
      {:ok, existing_list} ->
        :ets.insert(__MODULE__, {name, existing_list ++ value})
        {:reply, :ok, __MODULE__}

      :notfound ->
        :ets.insert(__MODULE__, {name, value})
        {:reply, :ok, __MODULE__}
    end

    # :ets.insert(__MODULE__, {name, value})
    # {:reply, :ok, __MODULE__}
  end

  # TODO: Finish delete
  def handle_call({:delete, name}, _from, __MODULE__) do
    # 6. Read and write to the ETS table
    # IO.inspect name
    :ets.delete(__MODULE__, name)
    {:reply, :ok, __MODULE__}
  end

  # TODO: Finish delete
  def handle_call({:remove, {name, value}}, _from, __MODULE__) do
    # 6. Read and write to the ETS table
    # IO.inspect name
    case lookup(name) do
      {:ok, existing_list} ->
        :ets.insert(__MODULE__, {name, existing_list -- value})
        # :ets.delete(__MODULE__, name)
        {:reply, :ok, __MODULE__}

      :error ->
        {:reply, :error, __MODULE__}

      :notfound ->
        {:reply, :notfound, __MODULE__}
    end
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
