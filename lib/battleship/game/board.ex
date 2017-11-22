defmodule Battleship.Game.Board do
  alias Battleship.Game
  alias Battleship.Game.Posn
  alias Battleship.Game.Ship

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
          if Enum.any?(board.placed_ships, fn(s) -> Ship.overlaps?(s, ship)) do
            {:error, :overlapping_ship}
          else
            {:ok, new_board}
          end
        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, :no_ships}
    end
  end

  def guess(board, posn) do
  end

  def over?(board) do
  end
end
