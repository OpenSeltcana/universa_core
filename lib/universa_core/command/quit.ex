defmodule Universa.Core.Command.Quit do
  @moduledoc """
  This component holds a list of command parsers to be evaluated.
  """
  use Universa.Core.Command
  @command_key "quit"

  def parse(entity_uuid, "quit", []) do
    ent = Universa.Core.EntityRegistry.get_entity(entity_uuid)
    :gen_tcp.send(
          Map.get(ent.components, "int_listener").value,
          "Thank you for using Universa.\r\nHopefully, see you next time!\r\n")
    :gen_tcp.close(Map.get(ent.components, "int_listener").value)
    true
  end

  def parse(_, "quit", _), do: false
end
