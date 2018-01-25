defmodule Universa do
  @moduledoc """
  Documentation for Universa.
  """

  @doc """
  Starts the two main supervisors, `Universa.Matter` and `Universa.Network`. Both are started by default, however they can be manually disabled by supplying START_MATTER=false and START_NETWORK=false respectively.

  NOTE: These variables may also be stored in the file .env

  ## Examples

      $ START_MATTER=n iex -S mix

  """
  def start(_type, _args) do
    # Start the Universa.Matter Supervisor, allowing the server to process
    # locations in the server.
    if Application.fetch_env!(:universa, :start_matter) do
      Universa.Matter.Supervisor.start_link()
    end

    # Start the Universa.Network Supervisor, allowing telnet clients to connect.
    if Application.fetch_env!(:universa, :start_network) do
      Universa.Network.Supervisor.start_link()
    end
  end
end
