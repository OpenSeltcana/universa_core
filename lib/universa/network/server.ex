defmodule Universa.Network.Server do

  def accept(port) do
    {:ok, so_listener} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    accept_clients(so_listener)
  end

  defp accept_clients(socket) do
    {:ok, so_client} = :gen_tcp.accept(socket)
    run_client(so_client)
    accept_clients(socket)
  end

  defp run_client(socket) do
    socket |> read_client() |> write_client(socket)
    run_client(socket)
  end

  defp read_client(socket) do
    {:ok, msg} = :gen_tcp.recv(socket, 0)
    msg
  end

  defp write_client(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
