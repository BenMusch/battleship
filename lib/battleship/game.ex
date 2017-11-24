defmodule Battleship.Game do
  use GenServer
  alias Battleship.Game
  alias Battleship.Game.Board
  alias Battleship.Game.Player

  defstruct [:player1, :player2]

  @board_size 10
  @ship_sizes [5, 4, 3, 3, 2]

  def board_size, do: @board_size
  def ship_sizes, do: @ship_sizes

  #################
  # GenServer Stuff
  #################

  def start_link(state \\ Game.new) do
    GenServer.start_link(__MODULE__, id, name: "#{__MODULE__}-#{id}")
  end

  def handle_call({:add_player, player_id}, _from, game) do
    {:reply, add_player(game, Player.new(player_id)), game}
  end

  def handle_call({:place, player_id, x1: x1, y1: y1, x2: x2, y2: y2}, _from, game) do
    case Posn.new(x1, y1) do
      {:ok, head} ->
        case Posn.new(x2, y2) do
          {:ok, tail} ->
            {:reply, place(game, player_id, head, tail), game}
          {:error, reason} ->
            {:reply, {:error, reason}, game}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, game}
    end
  end

  def handle_call({:guess, player_id, x: x, y: y}, _from, game) do
    case Posn.new(x, y) do
      {:ok, guess} ->
        {:reply, place(game, player_id, guess), game}
      {:error, reason} ->
        {:reply, {:error, reason}, game}
    end
  end

  def handle_call({:move, player_id, x, y})

  def init(state), do: {:ok, state}

  ############
  # Game Logic
  ############

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
