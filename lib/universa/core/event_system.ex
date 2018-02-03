defmodule Universa.Core.EventSystem do
  def event_component_create(entity_uuid, component) do
		Enum.each(Universa.Core.Hotplug.get_subscribed_systems(component),
      fn system ->
  			Task.Supervisor.start_child(Universa.Core.Events, fn ->
  				if is_atom(system) do
  					Kernel.apply(system, :handle,
                                    [entity_uuid, component, :component_create])
  				end
  			end)
  		end)
  end

  def event_component_change(entity_uuid, component) do
		Enum.each(Universa.Core.Hotplug.get_subscribed_systems(component),
      fn system ->
        IO.inspect {entity_uuid, component}
  			Task.Supervisor.start_child(Universa.Core.Events, fn ->
  				if is_atom(system) do
  					Kernel.apply(system, :handle,
                                  [entity_uuid, component, :component_changed])
  				end
  			end)
  		end)
  end

  def event_component_remove(entity_uuid, component) do
		Enum.each(Universa.Core.Hotplug.get_subscribed_systems(component),
      fn system ->
  			Task.Supervisor.start_child(Universa.Core.Events, fn ->
  				if is_atom(system) do
  					Kernel.apply(system, :handle,
                                    [entity_uuid, component, :component_remove])
  				end
  			end)
  		end)
  end
end
