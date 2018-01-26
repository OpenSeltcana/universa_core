defmodule Universa.Matter.System.DisplayName do
  @moduledoc """
  This system writes the names of Entities to console.
  """
  @behaviour Universa.Matter.Entity.System

  def component_keys, do: [:name]

  def perform(entity, _opts) do
    IO.puts entity.name
    entity
  end
end
