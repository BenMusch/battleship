defmodule Battleship.Game do
  alias Battleship.Game.Board
  alias Battleship.Game.Player

  defstruct [:player1, :player2]

  @board_size 10
  @ship_sizes [5, 4, 3, 3, 2]

  def board_size, do: @board_size
  def ship_sizes, do: @ship_sizes

  def new, do: %Game{}

  def add_player(game, player) do
    cond do
      game.player1 && game.player2 ->
        {:error, :full_game}
      game.player1 ->
        {:ok, %{ game | player2: player }}
      true ->
        {:ok, %{ game | player1: player }}
    end
  end

  def new_turn?(game) do
    game.player1.turns == game.player2.turns
  end

  def losers(game) do
    Enum.filter([game.player1, game.player2], fn(player) ->
      Board.over?(player.board)
    end)
  end

  def guess(game, player_id, posn) do
    opponent = opponent(game, player_id)
    {result, board} = Board.guess(opponent.board, posn)

    if result != :error do
      opponent = %{ opponent | board: board }
      Map.put(game, opponent_key(game, player_id), opponent)

      player = player(game, player_id) |> Player.turn!
      board = Map.put(game, player_key(game, player_id), player)
    end

    {result, game}
  end

  def place(game, player_id, head, tail) do
    player = player(game, player_id)
    case Board.place(player.board, head, tail) do
      {:ok, board} ->
        player = %{ player | board: board }
        {:ok, Map.put(game, player_key(game, player), player)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp opponent(game, player_id) do
    game[opponent_key(game, player_id)]
  end

  defp player(game, player_id) do
    game[player_key(game, player_id)]
  end

  defp player_key(game, player_id) do
    cond do
      player_id == game.player1.id ->
        :player1
      player_id == game.player2.id ->
        :player2
    end
  end

  defp opponent_key(game, player_id) do
    cond do
      player_id == game.player1.id ->
        :player2
      player_id == game.player2.id ->
        :player1
    end
  end
end
