defmodule Universa.Matter.Entity.Component.Listener do
  @moduledoc """
  This component gives an entity the ability to send events it witnesses back to a socket.
  """
  defstruct value: nil

  def new(uuid_sock), do: %__MODULE__{value: uuid_sock}
end
