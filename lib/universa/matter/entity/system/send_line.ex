defmodule Universa.Matter.System.SendLine do
  @behaviour Universa.Matter.Entity.System

  def component_keys, do: [:listener]

  def perform(entity, opts) do
    :gen_tcp.send(entity.listener.value, "#{opts.message}\r\n> ")
    entity
  end
end
