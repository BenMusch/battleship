defmodule BattleshipWeb.UserSocket do
  use Phoenix.Socket

  channel "player:*", BattleshipWeb.PlayerChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
