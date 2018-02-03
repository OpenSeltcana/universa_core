defmodule Universa.Core.Application do
  use Application

  def start(_type, _args) do
    children = [
      Universa.Core.Repo,
      Supervisor.child_spec({Task.Supervisor, [name: Universa.Core.Events]}, restart: :temporary, id: Universa.Core.EventSupervisor),
      {Registry, keys: :unique, name: Universa.Core.Network.Registry},
      {Task.Supervisor, name: Universa.Core.Network.Connections},
      Supervisor.child_spec({Task, fn ->
            Universa.Core.Network.Server.accept(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Universa.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
