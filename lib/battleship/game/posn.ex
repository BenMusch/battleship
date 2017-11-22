defmodule Battleship.Game.Posn do
  alias Battleship.Game
  alias Battleship.Game.Posn

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y) do
    if valid_component(x) && valid_component(y) do
      {:ok, %Posn{x: x, y: y}}
    else
      {:error, :invalid_coordinates}
    end
  end

  def distance(a, b) do
    x_comp = :math.pow(a.x - b.x, 2) |> round
    y_comp = :math.pow(a.y - b.y, 2) |> round

    :math.sqrt(x_comp + y_comp) |> round
  end

  defp valid_component(val) do
    val >= 0 && val < Game.board_size
  end
end
