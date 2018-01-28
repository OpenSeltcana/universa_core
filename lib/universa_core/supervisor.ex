defmodule Universa.Core.Supervisor do
  @moduledoc """
  This supervisor starts the `EntityRegistry` and the `NetworkServer` modules.
  """
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #Spawns an acceptor and a Supervisor for every open connection.
  def init(:ok) do
    children = [
      #Universa.Core.EntityRegistry,
      {Task.Supervisor, name: Universa.Core.NetworkConnections},
      Supervisor.child_spec({Task, fn ->
            Universa.Core.NetworkServer.accept(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Universa.Core.Supervisor]
    Supervisor.init(children, opts)
  end
end
