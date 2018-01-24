defmodule Universa do
  @moduledoc """
  Documentation for the Universa project pending
  """

  @doc """
  Hello world.

  ## Examples

      iex> Universa.hello
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do

    children = [
      {Task, fn -> Universa.Network.Server.accept(1234) end}
    ]

    opts     = [strategy: :one_for_one, name: Universa.Network.Server]
    Supervisor.start_link(children, opts)
end
end
