defmodule Battleship.Game.Board do
  alias Battleship.Game
  alias Battleship.Game.Posn
  alias Battleship.Game.Ship
  alias Battleship.Game.Board

  @enforce_keys [:unplaced_ships]
  defstruct [:unplaced_ships, :placed_ships, :guesses]

  def new do
    unplaced_ships = Enum.map(Game.ship_sizes, fn(size) ->
      {:ok, ship} = Ship.new(size)
      ship
    end)

    %Board{
      unplaced_ships: unplaced_ships,
      placed_ships: [],
      guesses: MapSet.new
    }
  end

  def opponent_view(board) do
    %{
      unplaced_ships: Enum.map(board.unplaced_ships, fn(s) -> s.size end),
      grid: transcribed_guesses(board, false)
    }
  end

  def owner_view(board) do
    %{
      unplaced_ships: Enum.map(board.unplaced_ships, fn(s) -> s.size end),
      grid: transcribed_guesses(board, true),
      placed_ships: Enum.map(board.placed_ships, fn(s) ->
        %{
          sunk: Ship.sunk?(s),
          coords: Enum.map(Ship.coords(s), fn(p) -> [p.x, p.y] end)
        }
      end)
    }
  end

  def place(board, head, tail) do
    ship_size = Posn.distance(head, tail) + 1
    ship = Enum.find(board.unplaced_ships, fn(s) -> s.size == ship_size end)
    i = Enum.find_index(board.unplaced_ships, fn(s) -> s.size == ship_size end)

    if ship != nil do
      case Ship.place(ship, head, tail) do
        {:ok, ship} ->
          if Enum.any?(board.placed_ships, fn(s) -> Ship.overlaps?(s, ship) end) do
            {:error, :overlapping_ship}
          else
            new_unplaced = List.delete_at(board.unplaced_ships, i)
            new_placed = [ship | board.placed_ships]
            {:ok, %{ board | unplaced_ships: new_unplaced, placed_ships: new_placed }}
          end
        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, :no_ships}
    end
  end

  def guess(board, guess) do
    if !MapSet.member?(board.guesses, guess) do
      board = %{ board | guesses: MapSet.put(board.guesses, guess) }
      if Enum.any?(board.placed_ships, fn(s) -> Ship.hit?(s, guess) end) do
        new_placed_ships = Enum.map(board.placed_ships, fn(s) ->
          if Ship.hit?(s, guess), do: Ship.hit!(s), else: s
        end)
        {:hit, %{ board | placed_ships: new_placed_ships }}
      else
        {:no_hit, board}
      end
    else
      {:no_hit, board}
    end
  end

  def over?(board) do
    Enum.all?(board.placed_ships, fn(s) -> s.sunk? end) && Enum.empty?(board.unplaced_ships)
  end

  defp transcribed_guesses(board, show_ships) do
    range = 0..(Game.board_size - 1)
    Enum.map(range, fn(y) ->
      Enum.map(range, fn(x) ->
        {:ok, posn} = Posn.new(x, y)

        ship_i = ship_at(board, posn)
        cond do
          ship_i == nil && MapSet.member?(board.guesses, posn) ->
            :GUESSED
          ship_i != nil && Ship.sunk?(Enum.at(board.placed_ships, ship_i)) ->
            :SUNK
          ship_i != nil && MapSet.member?(board.guesses, posn) ->
            :HIT
          ship_i != nil && show_ships ->
            :SHIP
          true ->
            :NOT_GUESSED
        end
      end)
    end)
  end

  # Returns the index of the ship located at the coordinates, if any
  defp ship_at(board, posn) do
    Enum.find_index(board.placed_ships, fn(s) -> Ship.hit?(s, posn) end)
  end
end
