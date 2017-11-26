defmodule BattleshipWeb.PlayerChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  def join("game:join", _payload, socket) do
    id = UUID.uuid1()
    case GameAgent.add_player(id) do
      {:ok, game} ->
        socket = socket |> assign(:player_id, id)
        IO.inspect(game)
        {:ok, game, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
