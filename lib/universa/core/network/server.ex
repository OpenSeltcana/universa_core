defmodule Universa.Core.Network.Server do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(
              Universa.Core.Network.Connections, fn -> first_serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp first_serve(socket) do
    entity_uuid = UUID.uuid1()
    Registry.register(Universa.Core.Network.Registry, entity_uuid, socket)

    Universa.Core.EventSystem.event_custom(entity_uuid, "io", [], :player_connect)

    serve(socket, entity_uuid)
  end

  defp serve(socket, entity_uuid) do
    case read_line(socket) do
      {:ok, data} ->
        Universa.Core.EventSystem.event_custom(entity_uuid, "io", data, :player_input)
        serve(socket, entity_uuid)
      {:error, :closed} -> :stop
    end
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end
end
