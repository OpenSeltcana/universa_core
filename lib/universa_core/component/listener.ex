defmodule Universa.Core.Component.Listener do
  @moduledoc """
  This component holds a socket at the moment, so data can be sent back.
  """
  use Universa.Core.Component
  @component_key "int_listener"

  defstruct value: nil

  def new(socket), do: %__MODULE__{value: socket}
end
