defmodule Universa.Matter.Map do
  @moduledoc """
  This module enables sockets to find the PID for the relevant Location!
  """
  use GenServer

  ## Client API

  @doc "Starts the Module."
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc "Looks up the Location pid, returns nil otherwise."
  def lookup(server, uuid_location) do
    GenServer.call(server, {:lookup, uuid_location})
  end

  @doc "Ensures there is a Location with given uuid."
  def create(server, uuid_location) do
    GenServer.cast(server, {:create, uuid_location})
  end

  @doc "Stops the Module."
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init(:ok) do
    names = %{}
    refs  = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, pid} = Universa.Matter.Map.LocationSupervisor.load_location(name)
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
