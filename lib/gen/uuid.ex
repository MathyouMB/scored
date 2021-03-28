defmodule Scored.Gen.Uuid do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{next_id: 0}}
  end

  # Client Methods
  def next_id() do
    GenServer.whereis(__MODULE__)
    |> GenServer.call(:next_id)
  end

  # Server Method
  def handle_call(:next_id, _from, state) do
    next_id = Map.get(state, :next_id)
    state = Map.put(state, :next_id, next_id + 1)
    {:reply, Map.get(state, :next_id), state}
  end
end
