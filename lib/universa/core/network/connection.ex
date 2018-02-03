defmodule Universa.Core.Network.Connection do
  def send(uuid, data) do
    :gen_tcp.send(find_uuid_socket(uuid), data)
  end

  defp find_uuid_socket(uuid) do
    [{_task, socket}] = Registry.lookup(Universa.Core.Network.Registry, uuid)
    socket
  end
end
