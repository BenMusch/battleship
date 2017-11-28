defmodule Battleship.Game do
  alias Battleship.Game
  alias Battleship.Game.Board
  alias Battleship.Game.Player

  defstruct [:player1, :player2]

  @board_size 10
  @ship_sizes [5, 4, 3, 3, 2]

  def board_size, do: @board_size
  def ship_sizes, do: @ship_sizes

  def new, do: %Game{}

  def view_for(game, player_id) do
    player = player(game, player_id)

    opponent = opponent(game, player_id)

    opponent_board = if opponent == nil, do: Board.new, else: opponent.board
    opponent_id = if opponent == nil, do: nil, else: opponent.id

    %{
      player: %{ id: player_id },
      opponent: Map.put(Board.opponent_view(opponent_board), :id, opponent_id),
      board: Board.owner_view(player.board)
    }
  end

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
    if Game.can_guess?(game, player_id) do
      opponent = opponent(game, player_id)
      {result, board} = Board.guess(opponent.board, posn)

      if result != :error do
        opponent = %{ opponent | board: board }
        game = Map.put(game, opponent_key(game, player_id), opponent)

        player = player(game, player_id) |> Player.turn!
        game = Map.put(game, player_key(game, player_id), player)
      end

      {result, game}
    else
      {:error, :cant_guess}
    end
  end

  def place(game, player_id, head, tail) do
    player = player(game, player_id)
    case Board.place(player.board, head, tail) do
      {:ok, board} ->
        player = %{ player | board: board }
        game = Map.put(game, player_key(game, player_id), player)
        {:ok, game}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def full?(game) do
    game.player1 != nil && game.player2 != nil
  end

  def can_guess?(game, player_id) do
    if full?(game) do
      turns_behind_opponent = opponent(game, player_id).turns - player(game, player_id).turns
      turns_behind_opponent == 1 || turns_behind_opponent == 0
    else
      false
    end
  end

  defp opponent(game, player_id) do
    Map.get(game, opponent_key(game, player_id))
  end

  defp player(game, player_id) do
    Map.get(game, player_key(game, player_id))
  end

  defp player_key(game, player_id) do
    # TODO: Have a 'waiting for an opponent' state
    cond do
      game.player1 != nil && player_id == game.player1.id ->
        :player1
      game.player2 != nil && player_id == game.player2.id ->
        :player2
      true ->
        nil
    end
  end

  defp opponent_key(game, player_id) do
    cond do
      player_id == game.player1.id ->
        :player2
      player_id == game.player2.id ->
        :player1
      true ->
        nil
    end
  end
end
