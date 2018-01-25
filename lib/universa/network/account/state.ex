defmodule Universa.Network.Account.Info do
  @moduledoc """
  Records all information needed from a socket perspective, such as if we are logged in and to what locations we need to send our commands.
  """
  defstruct name: nil, uuid: nil, locations: []
end
