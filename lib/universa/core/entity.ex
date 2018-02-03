defmodule Universa.Core.Entity do
  require Ecto.Query

  #TODO: Add some overwriting check?
	@spec add_component(String.t, String.t, term) :: String.t
	def add_component(entity_uuid, type, value) do
		{:ok, _} = %Universa.Core.Component{
					  type: type, entity_uuid: entity_uuid, value: value}
		|> Universa.Core.Repo.insert
    Universa.Core.EventSystem.event_component_create(entity_uuid, type, value)
		entity_uuid
	end

  @spec add_components_from_file(String.t, String.t) :: String.t
  def add_components_from_file(entity_uuid, path) do
    convert_to_location_path(path)
    |> read_file
    |> Enum.each(fn {type, value} ->
      if type != :unresolved do
        add_component(entity_uuid, type, value)
      end
    end)
		entity_uuid
	end

  @spec by_uuid(String.t) :: map()
  def by_uuid(entity_uuid) do
    filters = [entity_uuid: entity_uuid]

    Universa.Core.Component
    |> Ecto.Query.where(^filters)
    |> Universa.Core.Repo.all
    |> Enum.map(fn x -> {Map.get(x, :type), Map.get(x, :value)} end)
    |> Map.new()
  end

  @spec by_uuid_and_component(String.t, String.t) :: map
  def by_uuid_and_component(entity_uuid, type) do
    Universa.Core.Component
    |> Universa.Core.Repo.get_by(type: type, entity_uuid: entity_uuid)
    |> Map.get(:value)
  end

  @spec convert_to_location_path(String.t) :: String.t
  defp convert_to_location_path(relative_path) do
    File.cwd! |> Path.join("domain") |> Path.join(relative_path)
  end

	@spec create(String.t, term) :: String.t
	def create(type, value), do: add_component(UUID.uuid1(), type, value)

  @spec create_from_file(String.t) :: String.t
  def create_from_file(path), do: add_components_from_file(UUID.uuid1(), path)

  #TODO: How do we name the files again? Not templates but..?
  @spec read_file(String.t) :: map()
  defp read_file(path) do
    file = YamlElixir.read_from_file path
    components = Universa.Core.Hotplug.get_components_map

    list = Enum.into(file, %{unresolved: false}, fn {key, value} ->
      if Map.has_key?(components, key) do
        {key, Kernel.apply(Map.get(components, key), :new, [value])}
      else
        {:unresolved, true}
      end
    end)

    # Handle the "inherit" keyword
    if Map.has_key?(file, "inherit") do
      value = Map.get(file, "inherit")
      if is_list(value) do
        Enum.flat_map(value, fn rel_path ->
          read_file Path.expand(rel_path, Path.dirname(path))
        end)
        |> Map.new
        |> Map.merge(list)
      else
        Map.merge(read_file(Path.expand(value, Path.dirname(path))), list)
      end
    else
      list
    end
  end

  @spec remove(String.t) :: String.t
	def remove(entity_uuid) do
    filters = [entity_uuid: entity_uuid]

		Universa.Core.Component
		|> Ecto.Query.where(^filters)
		|> Universa.Core.Repo.all
		|> Universa.Core.Repo.delete_all
		entity_uuid
	end

  @spec remove_component(String.t, String.t) :: String.t
  def remove_component(entity_uuid, type) do
    {:ok, _} = Universa.Core.Component
    |> Universa.Core.Repo.get_by(type: type, entity_uuid: entity_uuid)
    |> Universa.Core.Repo.delete
    Universa.Core.EventSystem.event_component_remove(entity_uuid, type)
    entity_uuid
  end

	@spec set_component(String.t, String.t, term) :: String.t
	def set_component(entity_uuid, type, value) do
    safe_value = case is_map value do
      true -> value
      false -> %{"value" => value}
    end

		{:ok, _} = Universa.Core.Component
    |> Universa.Core.Repo.get_by(type: type, entity_uuid: entity_uuid)
		|> Universa.Core.Component.changeset(%{"value" => safe_value})
    |> Universa.Core.Repo.update

    Universa.Core.EventSystem.event_component_change(entity_uuid, type, value)
		entity_uuid
	end
end
