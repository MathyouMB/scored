defmodule Scored.Helpers.Rooms do
  def get_room_pid(id) do
    Registry.Rooms
    |> Registry.lookup(String.to_integer(id))
    |> List.last()
    |> Tuple.to_list()
    |> List.last()
  end
end
