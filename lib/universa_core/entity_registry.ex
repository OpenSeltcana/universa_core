defmodule Universa.Core.EntityRegistry do
  @moduledoc """
    The `EntityRegistry` module is a wrapper around the `Registry` started by `Universa.Core.Supervisor`
  """

  @typedoc "An entity UUID"
  @type uuid :: Universa.Core.UUID.t
  @typedoc "An Entity itself"
  @type entity :: Universa.Core.Entity.t

  @doc "Alias for adding a new Entity to the EntityRegistry."
  @spec spawn_entity(entity) :: {:ok, pid} | {:error, {:already_registered, pid}}
  def spawn_entity(entity) do
    Universa.Core.Entity.start_link(via_tuple(entity.id.value))
  end

  @doc "Alias for getting an Entity from the EntityRegistry."
  @spec get_entity(uuid) :: [{pid, entity}]
  def get_entity(id), do: Agent.get(via_tuple(id), fn entity -> entity end)

  @doc "Alias for changing an Entity in the EntityRegistry."
  @spec update_entity(entity) :: {term, term} | :error
  def update_entity(entity) do
    Agent.update(via_tuple(entity.id.value), fn _old_ent -> entity end)
  end

  @doc "Alias for removing an Entity from the EntityRegistry."
  @spec remove_entity(uuid) :: :ok
  def remove_entity(id) do
    Registry.unregister(Universa.Core.EntityRegistryServer, id)
  end

  @spec via_tuple(uuid) :: {:via, Registry, {atom, String.t}}
  defp via_tuple(id), do: {:via, Registry, {Universa.Core.EntityRegistryServer, id}}
end