defmodule Battleship.Game.Ship do
  alias Battleship.Game
  alias Battleship.Posn

  @enforce_keys [:len]
  defstruct [:len, :head, :tail]

  def create(size) do
    if Enum.member?(Game.ship_sizes, size) do
      {:ok, %Ship{size: size}}
    else
      {:error, :invalid_size}
    end
  end

  def place(ship, head, tail) do
    cond do
      Posn.distance(head, tail) != ship.len ->
        {:error, :posns_dont_match_ship_size}
      head.x != tail.x && head.y != tail.y ->
        {:error, :diagonal_ship}
      true ->
        {:ok, %{ ship | tail: tail, head: head }}
    end
  end

  def contains?(ship, posn) do
    Posn.distance(ship.head, posn) + Posn.distance(ship.tail, posn) ==
      Posn.distance(ship.head, ship.tail)
  end
end
