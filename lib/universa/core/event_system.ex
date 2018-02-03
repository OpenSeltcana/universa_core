defmodule Universa.Core.EventSystem do
  def event_component_create(entity_uuid, component, value) do
		event_custom(entity_uuid, component, value, :component_create)
  end

  def event_component_change(entity_uuid, component, value) do
		event_custom(entity_uuid, component, value, :component_changed)
  end

  def event_component_remove(entity_uuid, component) do
		event_custom(entity_uuid, component, [], :component_remove)
  end

  def event_custom(entity_uuid, event, args, type) do
    Enum.each(Universa.Core.Hotplug.get_subscribed_systems(event),
      fn system ->
  			Task.Supervisor.start_child(Universa.Core.Events, fn ->
  				if is_atom(system) do
  					Kernel.apply(system, :handle, [entity_uuid, event, args, type])
  				end
  			end)
  		end)
  end
end
