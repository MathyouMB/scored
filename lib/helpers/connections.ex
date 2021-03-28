defmodule Scored.Helpers.Connections do
  def publish(room_id, data) do
    Registry.Connections
    |> Registry.dispatch(room_id, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, data, [])
        end
      end
    end)
  end

  def publish_with_self(room_id, data) do
    Registry.Connections
    |> Registry.dispatch(room_id, fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, data, [])
      end
    end)
  end
end
