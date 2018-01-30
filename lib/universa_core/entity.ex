defmodule Universa.Core.Entity do
  use Agent

  alias Universa.Core.Entity

  defstruct id: nil, components: %{}

  @type id :: String.t
  @type component :: map
  @type t :: %Universa.Core.Entity {
    id: Universa.Core.UUID.t,
    components: map
  }

  def start_link({entity, name}) do
    Agent.start_link(fn -> entity end, name: name)
  end

  @doc "Creates a new Entity with given `UUID`"
  @spec new :: t
  def new, do: %Entity{ id: UUID.uuid1 }
  @spec new(map) :: t
  def new(components), do: %Entity{ id: UUID.uuid1, components: components }

  @doc "Adds a component to an entity, errors if the component already exists."
  @spec add_component(t, component) :: t
  def add_component(entity, component) do
    Map.update!(entity, :components, fn (_) -> Map.put_new(entity.components,
      component_to_key(component),
      component) end)
  end

  @doc "Checks if an entity has a component of specified type."
  @spec has(t, component) :: boolean
  def has(entity, component) do
    Map.has_key?(entity.components, component_to_key(component))
  end

  @doc "Removes a component from an entity."
  @spec remove_component(t, component) :: t
  def remove_component(entity, component) do
    Map.update!(entity, :components, fn (_) -> Map.delete(entity.components,
      component_to_key(component)) end)
  end

  @doc "Sets a component to specified value, should be if possible."
  @spec set(t, component) :: t
  def set(entity, component) do
    update_component(entity, component, fn(_) -> component end)
  end

  @doc "Applies changes to a `Component` in this `Entity` using a Function."
  @spec update_component(t, component, fun) :: t
  def update_component(entity, component, update_fn) do
    Map.update!(entity, :components, fn (_) -> Map.update!(entity.components,
      component, update_fn) end)
  end

  @spec component_to_key(component) :: String.t
  defp component_to_key(component) do
    component.__STRUCT__.component_key
  end
end
