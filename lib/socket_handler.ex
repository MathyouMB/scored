defmodule Scored.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    IO.inspect("init")
    IO.inspect(request)
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    IO.inspect("websocket_init")
    IO.inspect(state)
    IO.inspect(self())
    Registry.Scored
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    message = payload["data"]["message"]
    IO.inspect(message)

    Registry.Scored
    |> Registry.dispatch(state.registry_key, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)

    {:reply, {:text, message}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
