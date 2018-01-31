defmodule Universa.Core.EntityRegistry do
  @moduledoc """
    The `EntityRegistry` module is a wrapper around the `Registry` started by
     `Universa.Core.Supervisor`
  """

  @typedoc "An entity UUID"
  @type uuid :: Universa.Core.UUID.t
  @typedoc "An Entity itself"
  @type entity :: Universa.Core.Entity.t

  def spawn_entity() do
    entity = Universa.Core.Entity.new()
    {:ok, _pid} = DynamicSupervisor.start_child(Universa.Core.EntitySupervisor,
                  {Universa.Core.Entity, {entity, via_tuple( entity.id )}})
    entity.id
  end

  @doc "Alias for adding a new Entity to the EntityRegistry."
  @spec spawn_entity(entity) ::
                              {:ok, pid} | {:error, {:already_registered, pid}}
  def spawn_entity(entity) do
    {:ok, _pid} = DynamicSupervisor.start_child(Universa.Core.EntitySupervisor,
                  {Universa.Core.Entity, {entity, via_tuple( entity.id )}})

    Enum.each(entity.components, fn {key, value} ->
      Universa.Core.SystemRegistry.event_component_create(entity.id, key)
    end)

    entity # If successful, throw back the entity we just spawned, not the PID
  end

  @doc "Alias for getting an Entity from the EntityRegistry."
  @spec get_entity(uuid) :: [{pid, entity}]
  def get_entity(id), do: Agent.get(via_tuple(id), fn entity -> entity end)

  def add_entity_component(uuid, component, value) do
    Agent.update(via_tuple(uuid), fn entity ->
      IO.inspect entity
      Map.put(entity, component, value)
    end)
    Universa.Core.SystemRegistry.event_component_create(uuid, component)
    uuid
  end

  def get_entity_component(uuid, component) do
    Agent.get(via_tuple(uuid), fn entity ->
      IO.inspect({entity, component})
      Map.get(entity.components, component)
    end)
  end

  def update_entity_component(uuid, component, fun_change) do
    Agent.update(via_tuple(uuid), fn entity ->
      Map.update(entity, :components, 0, fn components ->
        Map.update(components, component,
                              Map.get(entity.components, component), fun_change)
      end)
    end)
    Universa.Core.SystemRegistry.event_component_change(uuid, component)
    uuid
  end

  def remove_entity_component(uuid, component) do
    Agent.update(via_tuple(uuid), fn entity ->
      Map.delete(entity.components, component)
    end)
    Universa.Core.SystemRegistry.event_component_remove(uuid, component)
    uuid
  end

  @doc "Alias for removing an Entity from the EntityRegistry."
  @spec remove_entity(uuid) :: :ok
  def remove_entity(id) do
    Registry.unregister(Universa.Core.EntityRegistryServer, id)
  end

  @doc "Gets a list of all entities in the registry."
  @spec entities :: list(pid)
  def entities do
    Supervisor.which_children(Universa.Core.EntitySupervisor)
      |> Enum.map(fn {_, pid, _, _} -> pid end)
  end

  @spec via_tuple(uuid) :: {:via, Registry, {atom, String.t}}
  defp via_tuple(id), do: {:via, Registry, {Universa.Core.EntityRegistryServer, id}}
end
