defmodule Universa.Core.NetworkServer do
  @moduledoc """
  This is the actual TCP server, accepting connections and spawning a new Task for every open connection.
  """
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Universa.Core.NetworkConnections,
                                                  fn -> first_serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp first_serve(socket) do
    ent = Universa.Core.EntityBuilder.build("system/player.yml")
    Universa.Core.Entity.add(ent, Universa.Core.Component.Listener.new(socket))
    Universa.Core.EntityRegistry.spawn_entity(ent)
    serve(socket, nil)
  end

  defp serve(socket, info) do
    info = case read_line(socket) do
      {:ok, data} -> Universa.Network.Parser.parse(data, info, socket)
    end

    serve(socket, info)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, text) do
    :gen_tcp.send(socket, text)
  end
end
