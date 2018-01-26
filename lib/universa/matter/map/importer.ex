defmodule Universa.Matter.Map.Importer do
  @moduledoc """
  This module imports the old state of a Location from long term storage to memory and back.
  """

  @doc "Moves a location from long term storage to memory."
  def load(uuid_location) do
    # TODO: Actually load rooms from somewhere
    case uuid_location do
      "1ebd411d-35d3-43cf-90eb-ceb547884e2d" -> {:ok, %{name: "Spawn room", description: "This is the first room everyone spawns in!"}}
      _ -> {:error, :unknown_location}
    end
  end

  @doc "Moves a location from memory to long term storage."
  def save(_uuid_location, _location) do
    # TODO: Actually store changes
  end
end