defmodule Universa.Matter.Map.Location do
  use Agent

  # TODO: Convert this to allow systems to work :D

  @doc "Initializes the Location."
  def start_link(opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc "Gets an entity from the Location."
  def get(location_pid, uuid_entity) do
    Agent.get(location_pid, &Map.get(&1, uuid_entity))
  end

  @doc "Gets all entities in the Location."
  def get(location_pid) do
    Agent.get(location_pid, &Map.values(&1))
  end

  @doc "Puts an entity into the Location."
  def set(location_pid, uuid_entity, entity) do
    Agent.update(location_pid, &Map.put(&1, uuid_entity, entity))
  end

  @doc "Puts an entity into the Location by loading it through `Universa.Matter.Entity.Importer`."
  def spawn(location_pid, uuid_entity, socket) do
    {:ok, entity} = Universa.Matter.Entity.Importer.load(uuid_entity, socket)
    set(location_pid, uuid_entity, entity)
  end

  @doc "Check if this Location has commands for players input."
  def push_input(location_pid, originating_uuid, input_line) do
    # TODO: Actually have a Map of commands in every Location
    case String.split(input_line, " ", parts: 2) do
      ["say" | message] ->
        entity = get(location_pid, originating_uuid)
        Universa.Matter.Entity.System.run(
            [Universa.Matter.System.SendLine],
            [entity],
            %{message: "#{entity.name} says, \"#{message}\""})

      ["date"] ->
        entity = get(location_pid, originating_uuid)
        Universa.Matter.Entity.System.run(
            [Universa.Matter.System.SendLine],
            [entity],
            %{message: "It is something something 2018"})

      ["help"] ->
        entity = get(location_pid, originating_uuid)
        Universa.Matter.Entity.System.run(
            [Universa.Matter.System.SendLine],
            [entity],
            %{message: "~~~ Commands~~~\r\nsay <message>\r\ndate\r\nhelp\r\n"})

      _ -> IO.puts "Unknown command: #{input_line}"

    end
  end
end
