defmodule Universa.Core.UUID do
  defstruct value: nil

  @type t :: %Universa.Core.UUID {
    value: String.t
  }

  @doc "Creates a new UUID based on time and node."
  @spec new :: t
  def new, do: %Universa.Core.UUID{value: UUID.uuid1}

  defimpl String.Chars do
    def to_string(%Universa.Core.UUID{value: name}), do: name
  end
end
