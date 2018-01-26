defmodule Universa.Matter.Entity.Importer do
  @moduledoc """
  This module imports the old state of a Entity from long term storage to memory and back.
  """

  @doc "Moves an entity from long term storage to memory."
  def load(uuid_entity, socket, name) do
    # TODO: Actually load rooms from somewhere
    case uuid_entity do
      _ -> {:ok, Universa.Matter.Entity.new([
        Universa.Matter.Entity.Component.Name.new(name),
        Universa.Matter.Entity.Component.Listener.new(socket)
      ])}
    end
  end

  @doc "Moves an entity from memory to long term storage."
  def save(_uuid_entity, _location) do
    # TODO: Actually store changes
  end
end
