defmodule Battleship.Game.Player do
  alias Battleship.Game.Board

  defstruct [:turns, :board, :id]

  def new(name) do
    %Player{turns: 0, board: Board.new, id: UUID.uuid1(), name: name}
  end

  def turn!(player) do
    %{ player | turns: player.turns + 1 }
  end

  def lost?(player) do
    Board.over?(player.board)
  end
end
