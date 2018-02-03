defmodule Universa.Core.System.OutputSender do
  use Universa.Core.System

  subscribe "io"

  def handle(entity_uuid, "io", value, :player_output) do
    :gen_tcp.send(find_uuid_socket(entity_uuid), value)
  end

  defp find_uuid_socket(uuid) do
    [{_task, socket}] = Registry.lookup(Universa.Core.Network.Registry, uuid)
    socket
  end
end
