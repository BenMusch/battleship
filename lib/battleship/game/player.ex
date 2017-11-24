defmodule Battleship.Game.Player do
  alias Battleship.Game.Board
  alias Battleship.Game.Player

  defstruct [:turns, :board, :id]

  def new(id) do
    %Player{turns: 0, board: Board.new, id: id}
  end

  def turn!(player) do
    %{ player | turns: player.turns + 1 }
  end

  def lost?(player) do
    Board.over?(player.board)
  end
end
