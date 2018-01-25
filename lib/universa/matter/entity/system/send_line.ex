defmodule Universa.Matter.System.SendLine do
  @behaviour Universa.Matter.Entity.System

  def component_keys, do: [:listener]

  def perform(entity) do
    #IO.puts entity.name
    entity
  end
end
