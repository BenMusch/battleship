defmodule BattleshipWeb.UserSocket do
  use Phoenix.Socket

  channel "game:*", BattleshipWeb.PlayerChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    {:ok, assign(socket, :player_id, params["player_id"])}
  end

  def id(_socket), do: nil
end
