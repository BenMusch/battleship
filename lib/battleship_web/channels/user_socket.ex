defmodule BattleshipWeb.UserSocket do
  use Phoenix.Socket

  channel "game:*", BattleshipWeb.PlayerChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"player_id": player_id}, socket) do
    {:ok, assign(socket, :player_id, player_id)}
  end

  def id(_socket), do: nil
end
