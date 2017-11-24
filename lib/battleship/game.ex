defmodule Battleship.Game do
  alias Battleship.Game
  alias Battleship.Game.Board
  alias Battleship.Game.Player

  defstruct [:player1, :player2]

  @board_size 10
  @ship_sizes [5, 4, 3, 3, 2]

  def board_size, do: @board_size
  def ship_sizes, do: @ship_sizes

  def new(player1, player2) do
    %Game{player1: player1, player2: player2}
  end

  def new_turn?(game) do
    game.player1.turns == game.player2.turns
  end

  def losers(game) do
    Enum.filter([game.player1, game.player2], fn(player) ->
      Board.over?(player.board)
    end)
  end

  def guess!(game, player_id, posn) do
    player = player(game, player_id) |> Player.turn!
    board = Map.put(game, player_key(player_id), player)

    opponent = opponent(player_id)
    {result, board} = Board.guess(opponent.board, posn)
    opponent = %{ opponent | board: board }
    Map.put(game, opponent_key(player_id), opponent)

    {result, game}
  end

  def place(game, player_id, head, tail) do
    player = player(game, player_id)
    case Board.place(player.board, head, tail) do
      {:ok, board} ->
        player = %{ player | board: board }
        {:ok, Map.put(game, player_key(player), player)}
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
    case player_id do
      game.player1.id ->
        :player1
      game.player2.id ->
        :player2
    end
  end

  defp opponent_key(game, player_id) do
    case player_id do
      game.player1.id ->
        :player2
      game.player2.id ->
        :player1
    end
  end
end
