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
      Posn.distance(head, tail) != ship.size ->
        {:error, :posns_dont_match_ship_size}
      head.x != tail.x && head.y != tail.y ->
        {:error, :diagonal_ship}
      true ->
        {:ok, %{ ship | tail: tail, head: head }}
    end
  end

  def hit?(ship, posn) do
    Posn.distance(ship.head, posn) + Posn.distance(ship.tail, posn) ==
      Posn.distance(ship.head, ship.tail)
  end

  def overlaps?(a, b) do
    cond do
      vertical?(a) == vertical?(b) ->
        # when parallel, check if a head/tail overlaps
        hit?(a, b.tail) || hit?(a, b.head)
      vertical?(a) ->
        (a.head.y >= b.head.y && a.tail.y <= b.head.y) ||
          (a.head.y <= b.head.y && a.tail.y >= b.head.y)
      vertical?(b) ->
        (b.head.y >= a.head.y && b.tail.y <= a.head.y) ||
          (b.head.y <= a.head.y && b.tail.y >= a.head.y)
    end
  end

  def hit!(ship) do
    %{ ship | hits: ship.hits + 1 }
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
