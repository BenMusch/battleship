defmodule Battleship.GameAgent do
  use GenServer
  alias Battleship.Game
  alias Battleship.Posn

  def start_link(state \\ Game.new) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def handle_call({:add_player, player_id}, _from, game) do
    {:reply, Game.add_player(game, Player.new(player_id)), game}
  end

  def handle_call({:place, player_id, x1: x1, y1: y1, x2: x2, y2: y2}, _from, game) do
    case Posn.new(x1, y1) do
      {:ok, head} ->
        case Posn.new(x2, y2) do
          {:ok, tail} ->
            {:reply, Game.place(game, player_id, head, tail), game}
          {:error, reason} ->
            {:reply, {:error, reason}, game}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, game}
    end
  end

  def handle_call({:guess, player_id, x: x, y: y}, _from, game) do
    case Posn.new(x, y) do
      {:ok, guess} ->
        {:reply, Game.guess(game, player_id, guess), game}
      {:error, reason} ->
        {:reply, {:error, reason}, game}
    end
  end

  def init(state), do: {:ok, state}
end
