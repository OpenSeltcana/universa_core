defmodule Universa.Core.Component.Listener do
  @moduledoc """
  This component holds a socket at the moment, so data can be sent back.
  """
  # We don't use Component, because we dont want YAML to have a listener option
  defstruct value: nil

  def new(socket), do: %__MODULE__{value: socket}
end
