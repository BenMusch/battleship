defmodule Battleship.GameAgent do
  use GenServer
  alias Battleship.Game
  alias Battleship.Game.Posn
  alias Battleship.Game.Player

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def create_game(game_id \\ UUID.uuidv1()) do
    GenServer.call(__MODULE__, {:create_game, game_id})
  end

  def add_player(game_id, player_id) do
    GenServer.call(__MODULE__, {:add_player, player_id})
  end

  def place(game_id, player_id, x1: x1, y1: y1, x2: x2, y2: y2) do
    GenServer.call(__MODULE__, {:place, player_id, x1: x1, y1: y1, x2: x2, y2: y2})
  end

  def guess(game_id, player_id, x: x, y: y) do
    GenServer.call(__MODULE__, {:guess, player_id, x: x, y: y})
  end

  def get_data(game_id, player_id) do
    GenServer.call(__MODULE__, {:get_data, player_id})
  end

  def handle_call({:create_game, game_id}, _from, games) do
    game = Game.new
    games = Map.put(games, game_id, game)
    {:reply, {:ok, game}, games}
  end

  def handle_call({:add_player, game_id, player_id}, _from, games) do
    game = Map.get(games, game_id)
    {result, game} = Game.add_player(game, Player.new(player_id))
    {:reply, {result, Game.view_for(game, player_id)}, games}
  end

  def handle_call({:place, game_id, player_id, x1: x1, y1: y1, x2: x2, y2: y2}, _from, games) do
    game = Map.get(games, game_id)

    case Posn.new(x1, y1) do
      {:ok, head} ->
        case Posn.new(x2, y2) do
          {:ok, tail} ->
            case Game.place(game, player_id, head, tail) do
              {:ok, game} ->
                games = Map.put(games, game_id, game)
                {:reply, {:ok, Game.view_for(game, player_id)}, games}
              {:error, reason} ->
                {:reply, {:error, reason}, games}
            end
          {:error, reason} ->
            {:reply, {:error, reason}, games}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, games}
    end
  end

  def handle_call({:guess, game_id, player_id, x: x, y: y}, _from, games) do
    game = Map.get(games, game_id)

    case Posn.new(x, y) do
      {:ok, guess} ->
        case Game.guess(game, player_id, guess) do
          {:error, reason} ->
            {:reply, {:error, reason}, games}
          {result, game} ->
            games = Map.put(games, game_id, game)
            {:reply, {:ok, Game.view_for(game, player_id)}, games}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, games}
    end
  end

  def handle_call({:get_data, game_id, player_id}, _from, games) do
    game = Map.get(games, game_id)
    {:reply, {:ok, Game.view_for(game, player_id)}, games}
  end

  def init(state), do: {:ok, state}
end
