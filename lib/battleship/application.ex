defmodule Battleship.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(BattleshipWeb.Endpoint, []),
      worker(Battleship.GameAgent, []),
    ]

    opts = [strategy: :one_for_one, name: Battleship.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BattleshipWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
