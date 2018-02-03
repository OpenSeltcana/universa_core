defmodule Universa.Core.Hotplug do
  #TODO Sting.to_atom and Atom.to_string calls should be safe to remove.

  #@doc "Given a module, checks function if compiled, otherwise attribute."
  @spec check_attribute_or_function(atom, atom) :: boolean
  defp check_attribute_or_function(module, attribute) do
    if Code.ensure_compiled?(module) do
      :erlang.function_exported(module, attribute, 0)
    else
      module.get_attribute(module, attribute)
    end
  end

  def get_components_map do
    get_modules()
    |> Enum.map(&String.to_atom(&1))
    |> Enum.filter(fn(module) ->
        check_attribute_or_function(module, :component_type)
      end)
    |> Enum.map(fn(module) ->
        {Kernel.apply(module, :component_type, []), module}
      end)
    |> Map.new
  end

  #@doc "Get a list of all modules subscribed to events regarding `Component`"
  @spec get_subscribed_systems(String.t) :: list(atom)
  def get_subscribed_systems(component) do
    map = Map.get(get_system_map(), component)
    case is_nil(map) do
      true -> []
      false -> map
    end
  end

  #TODO: Optimize (and possibly fix) this
  #@doc "Get a map of `%{component: [Module, ...]}`."
  @spec get_system_map :: map()
  defp get_system_map do
    map = get_modules()
      |> Enum.uniq
      |> Enum.map(&String.to_atom(&1))
      |> Enum.filter(fn(module) ->
          check_attribute_or_function(module, :subscribe_to_components)
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

  #@doc "Returns all loaded modules, (and unloaded ones if ran interactively)."
  @spec get_modules :: list(atom)
  defp get_modules do
    modules = Enum.map(:code.all_loaded, &Atom.to_string(elem(&1, 0)))

    case :code.get_mode() do
      :interactive -> modules ++ get_modules_from_applications()
      _otherwise -> modules
    end
  end

  #@doc "Get all modules in `Application` from a list of applications."
  @spec get_modules_from_applications :: list(atom)
  defp get_modules_from_applications do
     for [app] <- loaded_applications(),
         {:ok, modules} = :application.get_key(app, :modules),
         module <- modules do
       Atom.to_string(module)
     end
  end

  #@doc "Gets a list of every `Application` loaded interactively."
  @spec loaded_applications :: list(atom)
  defp loaded_applications do
    :ets.match(:ac_tab, {{:loaded, :"$1"}, :_})
  end
end
