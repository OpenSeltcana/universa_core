defmodule Universa.Core.System.Parser do
  use Universa.Core.System

  subscribe "io"

  def handle(entity_uuid, "io", value, :player_input) do
    IO.write "#{entity_uuid} typed: \"#{value}\"\r\n"
    Universa.Core.EventSystem.event_custom(entity_uuid, "io", "What?\r\n", :player_output)
  end
end
