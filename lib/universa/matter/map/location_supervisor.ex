defmodule Universa.Matter.Map.LocationSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @doc "Attempt to create a new `Universa.Matter.Map.Location` and use `Universa.Matter.Map.Importer` to load its starting state."
  def load_location(uuid_location) do
    {:ok, starting_state} = Universa.Matter.Map.Importer.load(uuid_location)
    Supervisor.start_child(__MODULE__, [])
  end

  def init(:ok) do
    Supervisor.init([Universa.Matter.Map.Location], strategy: :simple_one_for_one)
  end
end
