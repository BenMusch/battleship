defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  def join("player:" <> id, _payload, socket) do
    case GameAgent.add_player(id) do
      {:ok, game} ->
        socket = assign(socket, :player_id, id)
        {:ok, game, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("confirm_join", _params, socket) do
    if !socket.assigns[:confirmed] do
      socket = assign(socket, :confirmed, true)
      {:ok, game} = GameAgent.get_data(socket.assigns[:player_id])
      update_opponent!(game)
    end

    {:noreply, socket}
  end

  def handle_in("place", %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, socket) do
    player_id = socket.assigns[:player_id]
    case GameAgent.place(player_id, x1: x1, y1: y1, x2: x2, y2: y2) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_data(player_id)
        update_opponent!(game)
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  def handle_in("guess", %{"x" => x, "y" => y}, socket) do
    player_id = socket.assigns[:player_id]
    case GameAgent.guess(player_id, x: x, y: y) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_data(player_id)
        update_opponent!(game)
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  defp update_opponent!(game) do
    if game[:opponent][:id] != nil do
      id = game[:opponent][:id]
      {:ok, game} = GameAgent.get_data(id)
      BattleshipWeb.Endpoint.broadcast!("player:#{id}", "update", game)
    end
  end
end
