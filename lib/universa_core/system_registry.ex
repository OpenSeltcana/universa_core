defmodule Universa.Core.SystemRegistry do
  def event_component_create(uuid, component) do
    Task.async(fn ->
      Enum.each(get_subscribed_systems(component), fn system ->
        Task.async(fn ->
          if is_atom(system) do
            Kernel.apply(system, :handle, [:component_create, component, uuid])
          end
        end)
      end)
    end)
  end

  def event_component_change(uuid, component) do
    Task.async(fn ->
      Enum.each(get_subscribed_systems(component), fn system ->
        Task.async(fn ->
          if is_atom(system) do
            Kernel.apply(system, :handle, [:component_changed, component, uuid])
          end
        end)
      end)
    end)
  end

  def event_component_remove(uuid, component) do
    Task.async(fn ->
      Enum.each(get_subscribed_systems(component), fn system ->
        Task.async(fn ->
          if is_atom(system) do
            Kernel.apply(system, :handle, [:component_remove, component, uuid])
          end
        end)
      end)
    end)
  end

  defp get_subscribed_systems(component) do
    map = Map.get(get_system_map(), component)
    case is_nil(map) do
      true -> []
      false -> map
    end
  end

  defp get_system_map do
    map = get_modules()
      |> Enum.uniq
      |> Enum.map(&String.to_atom(&1))
      |> Enum.filter(fn(module) ->
          # If compiled, read the function
          if Code.ensure_compiled?(module) do
            :erlang.function_exported(module, :subscribe_to_components, 0)
          # If not compiled read the attribute
          else
            module.get_attribute(module, :subscribe_to_components)
          end
        end)
      |> Enum.map(fn(module) ->
          {Kernel.apply(module, :subscribe_to_components, []), module}
        end)

    map
    |> Enum.flat_map(fn({x, _}) -> x end)
    |> Enum.uniq
    |> Enum.map(fn key ->
      { key,
        Enum.map(map, fn {k, v} ->
          if Enum.find(k, fn(x) -> x === key end) == nil do
            {}
          else
            v
          end
        end)
      }
    end)
    |> Map.new
  end

  # Thanks so much for this, took it from:
  # https://github.com/elixir-lang/elixir/master/lib/iex/lib/iex/autocomplete.ex

  defp get_modules do
    modules = Enum.map(:code.all_loaded, &Atom.to_string(elem(&1, 0)))

    case :code.get_mode() do
      :interactive -> modules ++ get_modules_from_applications()
      _otherwise -> modules
    end
  end

  defp get_modules_from_applications do
     for [app] <- loaded_applications(),
         {:ok, modules} = :application.get_key(app, :modules),
         module <- modules do
       Atom.to_string(module)
     end
  end

  defp loaded_applications do
    :ets.match(:ac_tab, {{:loaded, :"$1"}, :_})
  end
end
