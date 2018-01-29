defmodule Universa.Core.CommandParser do
  def parse(entity_uuid, string) do
    [head | tail] = String.split(String.trim(string), " ")
    # TODO: Send a what? command if all return false
    #Enum.any?(Map.get(get_component_map, head), fn(module) ->
    #    Kernel.apply(module, :parse, [entity, head, tail])
    #  end)
    Kernel.apply(Map.get(get_component_map(), head), :parse,
                                                      [entity_uuid, head, tail])
  end

  defp get_component_map do
    get_modules()
      |> Enum.map(&String.to_atom(&1))
      |> Enum.filter(fn(module) ->
          # If compiled, read the function
          if Code.ensure_compiled?(module) do
            :erlang.function_exported(module, :command_key, 0)
          # If not compiled read the attribute
          else
            module.get_attribute(module, :command_key)
          end
        end)
      |> Enum.map(fn(module) ->
          {Kernel.apply(module, :command_key, []), module}
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
