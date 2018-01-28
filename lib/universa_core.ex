defmodule Universa.Core do
  @moduledoc """
  Documentation for UniversaCore.
  """

  def start(_type, _args), do: Supervisor.start_link(children(), options())
  defp children(), do: []
  defp options(),  do: [strategy: :one_for_one, name: UniversaCore.Supervisor]

  def launch(parser \\ Universa.Core.Parser.That.Aint.There) do
    :world
  end
end
