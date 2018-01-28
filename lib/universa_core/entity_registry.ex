defmodule Universa.Core.EntityRegistry do
  @moduledoc """
    The `EntityRegistry` module is a key, value Registry linking every `Entity` to an `UUID`. Short version, its a wrapper around `Registry`.
  """

  use GenServer

  @typedoc "An entity UUID"
  @type uuid :: Universa.Core.UUID.t
  @typedoc "An Entity itself"
  @type entity :: Universa.Core.Entity.t

  @doc "Starts the EntityRegistry, most likely used by a Supervisor!"
  def start_link(_opts) do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  @doc "Alias for adding a new Entity to the EntityRegistry."
  @spec spawn_entity(uuid, entity) ::
      {:ok, pid} | {:error, {:already_registered, pid}}
  def spawn_entity(id, entity), do: Registry.register(__MODULE__, id, entity)

  @doc "Alias for getting an Entity from the EntityRegistry."
  @spec get_entity(uuid) :: [{pid, entity}]
  def get_entity(id), do: Registry.lookup(__MODULE__, id)

  @doc "Alias for changing an Entity in the EntityRegistry."
  @spec update_entity(uuid, entity) :: {term, term} | :error
  def update_entity(id, entity), do: Registry.update_value(__MODULE__, id, entity)

  @doc "Alias for removing an Entity from the EntityRegistry."
  @spec remove_entity(uuid) :: :ok
  def remove_entity(id), do: Registry.unregister(__MODULE__, id)
end
