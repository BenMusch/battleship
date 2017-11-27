defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  def join("game:join", _payload, socket) do
    id = UUID.uuid1()
    case GameAgent.add_player(id) do
      {:ok, game} ->
        socket = assign(socket, :player_id, id)
        IO.inspect(game)
        {:ok, game, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("place", %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, socket) do
    player_id = socket.assigns[:player_id]
    case GameAgent.place(player_id, x1: x1, y1: y1, x2: x2, y2: y2) do
      {:ok, game} ->
        {:ok, {:ok, game}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
