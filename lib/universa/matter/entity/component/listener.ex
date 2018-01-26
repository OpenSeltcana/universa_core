defmodule Universa.Matter.Entity.Component.Listener do
  @moduledoc """
  This component holds a socket at the moment, so data can be sent back.
  """
  defstruct value: nil

  def new(socket), do: %__MODULE__{value: socket}
end
