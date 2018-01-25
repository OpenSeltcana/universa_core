defmodule Universa.Matter.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #Spawns an acceptor and a Supervisor for every open connection.
  def init(:ok) do
    children = [
      {Universa.Matter.Map.LocationSupervisor, name: Universa.Matter.Map.LocationSupervisor},
      {Universa.Matter.Map, name: Universa.Matter.Map}
    ]

    opts = [strategy: :one_for_one, name: Universa.Matter.Supervisor]
    Supervisor.init(children, opts)
  end
end
