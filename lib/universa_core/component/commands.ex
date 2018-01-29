defmodule Universa.Core.Component.Commands do
  @moduledoc """
  This component holds a list of command parsers to be evaluated.
  """
  use Universa.Core.Component
  @component_key "commands"

  defstruct value: []

  def new(commands), do: %__MODULE__{value: commands}
end
