defmodule Battleship.Game do
  @board_size 10
  @ship_sizes [5, 4, 3, 3, 2]

  def board_size, do: @board_size
  def ship_sizes, do: @ship_sizes
end
