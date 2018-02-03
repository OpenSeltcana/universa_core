defmodule Universa.Core.System.Parser do
  use Universa.Core.System

  subscribe "input"

  def handle(_entity, "input", :component_changed) do
    IO.write "A player typed something"
  end
end
