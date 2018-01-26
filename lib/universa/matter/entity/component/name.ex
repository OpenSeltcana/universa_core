defmodule Universa.Matter.Entity.Component.Name do
  @moduledoc """
  This component gives an entity a name, people like names.
  """
  defstruct value: nil

  def new(name), do: %__MODULE__{value: name}

  defimpl String.Chars do
    def to_string(%{value: name}), do: name
  end
end
