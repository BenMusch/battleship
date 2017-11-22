defmodule Battleship.Game.Board do
  alias Battleship.Game
  alias Battleship.Game.Posn
  alias Battleship.Game.Ship
  alias Battleship.Game.Board

  @enforce_keys [:unplaced_ships]
  defstruct [:unplaced_ships, :placed_ships, :guesses]

  def new do
    unplaced_ships = Enum.map(Game.ship_sizes, fn(size) ->
      {:ok, ship} = Ship.create(size)
      ship
    end)

    %Board{
      unplaced_ships: unplaced_ships,
      placed_ships: [],
      guesses: MapSet.new
    }
  end

  def place(board, ship_size, head, tail) do
    ship = Enum.find(board.unplaced_ships, fn(s) -> s.size == ship_size end)

    if ship != nil do
      case Ship.place(ship, head, tail) do
        {:ok, ship} ->
          if Enum.any?(board.placed_ships, fn(s) -> Ship.overlaps?(s, ship) end) do
            {:error, :overlapping_ship}
          else
            new_unplaced = List.delete(board.unplaced_ships, ship)
            new_placed = [ship | board.unplaced_ships]
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
end
