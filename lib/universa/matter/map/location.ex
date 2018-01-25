defmodule Universa.Matter.Map.Location do
  use Agent

  # TODO: Convert this to allow systems to work :D

  @doc "Initializes the Location."
  def start_link(opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc "Gets an entity from the Location."
  def get(uuid_location, uuid_entity) do
    Agent.get(uuid_location, &Map.get(&1, uuid_entity))
  end

  @doc "Gets all entities in the Location."
  def get(uuid_location) do
    Agent.get(uuid_location, &Map.values(&1))
  end

  @doc "Puts an entity into the Location."
  def set(uuid_location, uuid_entity, entity) do
    Agent.update(uuid_location, &Map.put(&1, uuid_entity, entity))
  end

  @doc "Puts an entity into the Location by loading it through `Universa.Matter.Entity.Importer`."
  def spawn(uuid_location, uuid_entity, account_state) do
    {:ok, entity} = Universa.Matter.Entity.Importer.load(uuid_entity, account_state.uuid)
    set(uuid_location, uuid_entity, entity)
  end

  def push_input(account, input_line) do
    IO.puts account.name
    IO.puts input_line
  end
end
