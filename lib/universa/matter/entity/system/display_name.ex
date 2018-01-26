defmodule Universa.Matter.System.DisplayName do
  @behaviour Universa.Matter.Entity.System

  def component_keys, do: [:name]

  def perform(entity, _opts) do
    IO.puts entity.name
    entity
  end
end
