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
    {:ok, pid} = Task.Supervisor.start_child(Universa.Network.Connections,
                                                  fn -> first_serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp first_serve(socket) do
    write_line(socket, """
\x1B[33m      .-  _             _  -.\r
     /   /  .         .  \\   \\ \x1B[35m    .   .     o\r
\x1B[33m    (   (  (  \x1B[36m (-o-) \x1B[33m  )  )   ) \x1B[35m   |   |,---...    ,,---.,---.,---.,---.\r
\x1B[33m     \\   \\_ ` \x1B[36m  |x|\x1B[33m   ` _/   /  \x1B[35m   |   ||   || \\  / |---'|    `---.,---|\r
\x1B[33m      `-      \x1B[36m  |x|\x1B[33m        -`   \x1B[35m   `---'`   '`  `'  `---'`    `---'`---^\r
              \x1B[36m  |x|\x1B[39m\r
\r
    Enter your nickname:\r
""")
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
