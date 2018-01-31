defmodule Universa.Core.System.Parser do
  use Universa.Core.System

  subscribe "input"

  def handle(:component_changed, "input", _entity) do
    IO.write "A player typed something"
  end
end
