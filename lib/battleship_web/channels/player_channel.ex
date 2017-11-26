defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  def join("player:game", _payload, socket) do
    id = UUID.uuid1()
    case GameAgent.add_player(id) do
      {:ok, game} ->
        socket = socket |> assign(:player_id, id)
        IO.inspect(game)
        {:ok, %{id: id}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
