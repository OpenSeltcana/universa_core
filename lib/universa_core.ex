defmodule Universa.Core do
  @moduledoc """
  Documentation for UniversaCore.
  """

  def start(_type, _args) do
    children = [
      {Universa.Core.Supervisor, name: Universa.Core.Supervisor}
    ]

    opts     = [strategy: :one_for_one, name: Universa.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
