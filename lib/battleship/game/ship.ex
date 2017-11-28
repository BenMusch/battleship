defmodule Battleship.Game.Ship do
  alias Battleship.Game
  alias Battleship.Game.Posn
  alias Battleship.Game.Ship

  @enforce_keys [:size]
  defstruct [:size, :head, :tail, :hits]

  def new(size) do
    if Enum.member?(Game.ship_sizes, size) do
      {:ok, %Ship{size: size, hits: 0}}
    else
      {:error, :invalid_size}
    end
  end

  def place(ship, head, tail) do
    cond do
      Posn.distance(head, tail) + 1 != ship.size ->
        {:error, :posns_dont_match_ship_size}
      head.x != tail.x && head.y != tail.y ->
        {:error, :diagonal_ship}
      true ->
        {:ok, %{ ship | tail: tail, head: head }}
    end
  end

  def hit?(ship, posn) do
    Enum.any?(coords(ship), fn(p) -> p.x == posn.x && p.y == posn.y end)
  end

  def overlaps?(a, b) do
    Enum.any?(Ship.coords(a), fn(posn1) ->
      Enum.any?(Ship.coords(b), fn(posn2) -> posn2.x == posn1.x && posn2.y == posn1.y end)
    end)
  end

  def hit!(ship) do
    %{ ship | hits: ship.hits + 1 }
  end

  def coords(ship) do
    if vertical?(ship) do
      Enum.map((ship.head.y)..(ship.tail.y), fn(y) ->
        {:ok, posn} = Posn.new(ship.head.x, y)
        posn
      end)
    else
      Enum.map((ship.head.x)..(ship.tail.x), fn(x) ->
        {:ok, posn} = Posn.new(x, ship.head.y)
        posn
      end)
    end
  end

  def sunk?(ship) do
    ship.hits == ship.size
  end

  defp vertical?(ship) do
    ship.head.x == ship.tail.x
  end

  defp horizontal?(ship) do
    ship.head.y == ship.tail.y
  end
end
