defmodule Scored.Gen.Room do
  use GenServer

  def start_link(uuid) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok)

    Registry.Rooms
    |> Registry.register(uuid, pid)

    {:ok, pid}
  end

  def init(:ok) do
    {:ok,
     %{
       votes: [],
       hidden: true,
       member_count: 0
     }}
  end

  # Client Methods
  def state(pid) do
    GenServer.call(pid, :state)
  end

  def all_votes(pid) do
    GenServer.call(pid, :all_votes)
  end

  def add_vote(pid, vote) do
    GenServer.cast(pid, {:add_vote, vote})
  end

  def reveal_votes(pid) do
    GenServer.cast(pid, :reveal_votes)
  end

  def reset_votes(pid) do
    GenServer.cast(pid, :reset_votes)
    GenServer.cast(pid, :reset_hidden)
  end

  def update_member_count(pid, increment) do
    GenServer.cast(pid, {:update_member_count, increment})
  end

  # Server methods
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:all_votes, _from, state) do
    {:reply, Map.get(state, :votes), state}
  end

  def handle_cast({:add_vote, vote}, state) do
    votes = Map.get(state, :votes)
    {:noreply, Map.put(state, :votes, votes ++ [vote])}
  end

  def handle_cast(:reveal_votes, state) do
    {:noreply, Map.put(state, :hidden, false)}
  end

  def handle_cast(:reset_votes, state) do
    {:noreply, Map.put(state, :votes, [])}
  end

  def handle_cast(:reset_hidden, state) do
    {:noreply, Map.put(state, :hidden, true)}
  end

  def handle_cast({:update_member_count, increment}, state) do
    count = Map.get(state, :member_count)
    {:noreply, Map.put(state, :member_count, count + increment)}
  end
end
