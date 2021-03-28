defmodule Scored.Router do
  alias Scored.Gen.Uuid, as: UUID
  use Plug.Router
  require EEx

  plug(Plug.Static,
    at: "/",
    from: :scored
  )

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  EEx.function_from_file(:defp, :home_html, "lib/web/home.html", [])
  EEx.function_from_file(:defp, :room_html, "lib/web/room.html", [])

  get "/" do
    send_resp(conn, 200, home_html())
  end

  get "/:room_id" do
    pid = Scored.Helpers.Rooms.get_room_pid(room_id)

    if is_nil(pid), do: send_resp(conn, 404, "ERROR")

    send_resp(conn, 200, room_html())
  end

  get "/api/:room_id" do
    data =
      Scored.Helpers.Rooms.get_room_pid(room_id)
      |> Scored.Gen.Room.state()

    response = Jason.encode!(%{"room" => data})
    send_resp(conn, 200, response)
  end

  post "/api/create" do
    uuid = UUID.next_id()
    Scored.Supervisor.RoomSupervisor.create_room(uuid)

    send_resp(conn, 200, Jason.encode!(%{"room_id" => Integer.to_string(uuid)}))
  end

  put "/api/reveal/:room_id" do
    pid = Scored.Helpers.Rooms.get_room_pid(room_id)
    Scored.Gen.Room.reveal_votes(pid)

    data =
      %{
        room: Scored.Gen.Room.state(pid),
        message: "owner_revealed"
      }
      |> Jason.encode!()

    Scored.Helpers.Connections.publish(room_id, data)
    send_resp(conn, 200, data)
  end

  put "/api/reset/:room_id" do
    pid = Scored.Helpers.Rooms.get_room_pid(room_id)
    Scored.Gen.Room.reset_votes(pid)

    data =
      %{
        room: Scored.Gen.Room.state(pid),
        message: "owner_reset"
      }
      |> Jason.encode!()

    Scored.Helpers.Connections.publish(room_id, data)
    send_resp(conn, 200, data)
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
