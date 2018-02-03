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

    input_path = Universa.Core.Component.Input.new("")
    output_path = Universa.Core.Component.Output.new("")

    entity_uuid
    |> Universa.Core.Entity.add_component("input", input_path)
    |> Universa.Core.Entity.add_component("output", output_path)

    serve(socket, entity_uuid)
  end

  defp serve(socket, entity_uuid) do
    case read_line(socket) do
      {:ok, data} ->
        Universa.Core.Entity.set_component(entity_uuid, "input", data)
        serve(socket, entity_uuid)
      {:error, :closed} -> :stop
    end
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end
end
