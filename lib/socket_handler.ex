defmodule Scored.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    room_id = String.split(request.path, "/") |> List.last()
    state = %{registry_key: room_id}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.Connections
    |> Registry.register(state.registry_key, {})

    pid = Scored.Helpers.Rooms.get_room_pid(state.registry_key)
    Scored.Gen.Room.update_member_count(pid, 1)

    data =
      %{
        room: Scored.Gen.Room.state(pid),
        message: "member_joined"
      }
      |> Jason.encode!()

    Scored.Helpers.Connections.publish_with_self(state.registry_key, data)
    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    vote = payload["data"]["vote"]

    pid = Scored.Helpers.Rooms.get_room_pid(state.registry_key)
    Scored.Gen.Room.add_vote(pid, vote)

    data =
      %{
        room: Scored.Gen.Room.state(pid),
        message: "member_voted"
      }
      |> Jason.encode!()

    Scored.Helpers.Connections.publish(state.registry_key, data)
    {:reply, {:text, data}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  def terminate(_reason, _partial_req, state) do
    pid = Scored.Helpers.Rooms.get_room_pid(state.registry_key)
    Scored.Gen.Room.update_member_count(pid, -1)

    data =
      %{
        room: Scored.Gen.Room.state(pid),
        message: "member_left"
      }
      |> Jason.encode!()

    Scored.Helpers.Connections.publish(state.registry_key, data)
  end
end
