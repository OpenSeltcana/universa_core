defmodule Universa.Network.Supervisor do
  @moduledoc """
  This supervisor starts the ListenServer (so we are listening on a port) and a TaskSupervisor that manages all the open connections.
  """
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #Spawns an acceptor and a Supervisor for every open connection.
  def init(:ok) do
    children = [
      {Task.Supervisor, name: Universa.Network.Connections},
      Supervisor.child_spec({Task, fn -> Universa.Network.ListenServer.accept(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Universa.Network.Supervisor]
    Supervisor.init(children, opts)
  end
end
