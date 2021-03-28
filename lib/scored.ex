defmodule Scored do
  # Application Module tells the Erlang VM that our app is an application to monitor.
  use Application

  def start(_type, _args) do
    children = [
      Scored.Gen.Uuid,
      DynamicSupervisor.child_spec(
        strategy: :one_for_one,
        name: Scored.Supervisor.RoomSupervisor
      ),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Scored.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :unique,
        name: Registry.Rooms
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Connections
      )
    ]

    opts = [strategy: :one_for_one, name: Scored.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/:room_id", Scored.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Scored.Router, []}}
       ]}
    ]
  end
end
