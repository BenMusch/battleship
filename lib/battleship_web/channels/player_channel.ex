defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  def join("game:" <> game_id, _payload, socket) do
    if GameAgent.exists?(game_id) do
      {:ok, game} = GameAgent.create_game(game_id)
    end
    player_id = socket.assigns[:player_id]

    case GameAgent.add_player(game_id, player_id) do
      {:ok, game_id} ->
        socket = assign(socket, :game_id, game_id)
        {:ok, game_id, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("confirm_join", _params, socket) do
    if !socket.assigns[:confirmed] do
      socket = assign(socket, :confirmed, true)
      {:ok, game} = GameAgent.get_data(socket.assigns[:game_id], socket.assigns[:player_id])
      update_opponent!(game)
    end

    {:noreply, socket}
  end

  def handle_in("place", %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, socket) do
    game_id = socket.assigns[:game_id]
    player_id = socket.assigns[:player_id]
    case GameAgent.place(game_id, player_id, x1: x1, y1: y1, x2: x2, y2: y2) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_data(game_id, player_id)
        update_opponent!(game)
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  def handle_in("guess", %{"x" => x, "y" => y}, socket) do
    game_id = socket.assigns[:game_id]
    player_id = socket.assigns[:player_id]
    case GameAgent.guess(game_id, player_id, x: x, y: y) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_data(game_id, player_id)
        update_opponent!(game)
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  defp update_opponent!(game) do
    if game[:opponent][:id] != nil do
      id = game[:opponent][:id]
      {:ok, game} = GameAgent.get_data(game[:id], id)
      BattleshipWeb.Endpoint.broadcast!("game:#{id}", "update", game)
    end
  end
end
