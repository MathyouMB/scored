defmodule Scored.Supervisor.RoomSupervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_room(uuid) do
    DynamicSupervisor.start_child(__MODULE__, {Scored.Gen.Room, uuid})
  end
end
