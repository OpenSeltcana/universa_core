defmodule Universa.Core.EntityBuilder do
  def build(location) do
    location
      |> convert_to_location_path
      |> template_to_location
      |> Universa.Core.Entity.new
  end

  defp convert_to_location_path(relative_path) do
    File.cwd! |> Path.join("domain") |> Path.join(relative_path)
  end

  defp template_to_location(path) do
    template = YamlElixir.read_from_file path
    components = get_components_map()

    new_template = Enum.into(template, %{unresolved: false}, fn {key, value} ->
      if Map.has_key?(components, key) do
        {key, Kernel.apply(Map.get(components, key), :new, [value])}
      else
        {:unresolved, true}
      end
    end)

    # Handle the "inherit" keyword
    if Map.has_key?(template, "inherit") do
      value = Map.get(template, "inherit")
      if is_list value do
        Enum.flat_map(value, fn rel_path ->
          template_to_location Path.expand(rel_path, Path.dirname(path))
        end)
        |> Map.new
        |> Map.merge(new_template)
      else
        Map.merge(template_to_location(Path.expand(value, Path.dirname(path))),
                                                                  new_template)
      end
    else
      new_template
    end
  end

  defp get_components_map do
    get_modules()
      |> Enum.map(&String.to_atom(&1))
      |> Enum.filter(fn(module) ->
          # If compiled, read the function
          if Code.ensure_compiled?(module) do
            :erlang.function_exported(module, :component_key, 0)
          # If not compiled read the attribute
          else
            module.get_attribute(module, :component_key)
          end
        end)
      |> Enum.map(fn(module) ->
          {Kernel.apply(module, :component_key, []), module}
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
