defmodule Universa.Matter.Map.Location do
  @moduledoc """
  This is a single location which contains Entities, so they can affect eachother!
  """

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
  def spawn(location_pid, uuid_entity, socket, name) do
    {:ok, entity} = Universa.Matter.Entity.Importer.load(uuid_entity, socket, name)
    generated_uuid = UUID.uuid1()
    set(location_pid, generated_uuid, entity)
    # Send
    Universa.Matter.Entity.System.run(
        [Universa.Matter.System.SendLine],
        get(location_pid),
        %{message: "#{name} has entered the game."})
    generated_uuid
  end

  @doc "Check if this Location has commands for players input."
  def push_input(location_pid, originating_uuid, input_line) do
    # TODO: Actually have a Map of commands in every Location

    # Simple case to get the first word and pass it to code specific to that command.
    case String.split(input_line, " ", parts: 2) do
      ["say" | message] ->
        entity = get(location_pid, originating_uuid)
        Universa.Matter.Entity.System.run(
            [Universa.Matter.System.SendLine],
            get(location_pid),
            %{message: "#{entity.name} says, \"#{message}\""})

      ["emote" | message] ->
              entity = get(location_pid, originating_uuid)
              Universa.Matter.Entity.System.run(
                  [Universa.Matter.System.SendLine],
                  get(location_pid),
                  %{message: "->#{entity.name} #{message}."})

      ["yawn"] ->
              entity = get(location_pid, originating_uuid)
              Universa.Matter.Entity.System.run(
                  [Universa.Matter.System.SendLine],
                  get(location_pid),
                  %{message: "#{entity.name} yawns."})

      ["smile"] ->
              entity = get(location_pid, originating_uuid)
              Universa.Matter.Entity.System.run(
                  [Universa.Matter.System.SendLine],
                  get(location_pid),
                  %{message: "#{entity.name} smiles."})

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
            %{message: "\n~~~ Commands~~~\r\nsay <message>\r\ndate\r\nhelp\r\n"})

      _ -> IO.puts "Unknown command: #{input_line}"

    end
  end
end
