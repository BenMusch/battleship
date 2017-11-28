defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  intercept ["update"]

  def join("game:" <> game_id, _payload, socket) do
    if !GameAgent.exists?(game_id)do
      {:ok, game_id} = GameAgent.create_game(game_id)
    end

    player_id = socket.assigns[:player_id]

    case GameAgent.add_player(game_id, player_id) do
      {:ok, game} ->
        socket = assign(socket, :game_id, game_id)
        push_update!(game_id, game[:opponent][:id])
        {:ok, game, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("place", %{"x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, socket) do
    game_id = socket.assigns[:game_id]
    player_id = socket.assigns[:player_id]
    case GameAgent.place(game_id, player_id, x1: x1, y1: y1, x2: x2, y2: y2) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_data(game_id, player_id)
        push_update!(game_id, game[:opponent][:id])
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
        push_update!(game_id, game[:opponent][:id])
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  def handle_out("update", game_data, socket) do
    player_id = game_data[:player][:id]
    game_id = socket.assigns[:game_id]

    if game_id && player_id && player_id == socket.assigns[:player_id] do
      push socket, "update", game_data
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  defp push_update!(game_id, player_id) do
    if player_id do
      {:ok, game_data} = GameAgent.get_data(game_id, player_id)
      BattleshipWeb.Endpoint.broadcast!("game:#{game_id}", "update", game_data)
    end
  end
end
