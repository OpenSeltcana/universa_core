defmodule Universa.Core do
  @moduledoc """
  Documentation for UniversaCore.
  """

  use Application

  def start(_type, _args), do: Universa.Core.Supervisor.start_link([])
end
