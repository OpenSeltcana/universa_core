defmodule Universa.Network.Parser do
  @moduledoc """
  Converts input from a client into a common format for every parser.
  """

  @doc "Temporary way of solving the command problem."
  def parse(input_line, info) do
    # TODO: Authentication

    # If we dont have an account yet, create one with the name the user inputted.
    if info == nil do
      {:ok, info} = Universa.Network.Account.Importer.load(String.trim(input_line))

      # Now for every location we are in, create our player entity
      # TODO: Read the locations from info
      Universa.Matter.Map.create(Universa.Matter.Map, "1ebd411d-35d3-43cf-90eb-ceb547884e2d")
      lookup "1ebd411d-35d3-43cf-90eb-ceb547884e2d", fn pid ->
        Universa.Matter.Map.Location.spawn(pid, "test_entity_uuid", info)
        entities = Universa.Matter.Map.Location.get(pid)
        Universa.Matter.Entity.System.run([Universa.Matter.System.DisplayName], entities)
      end
    else
      # TODO: Read the locations from info
      lookup("1ebd411d-35d3-43cf-90eb-ceb547884e2d", fn pid ->
        Universa.Matter.Map.Location.push_input(info, input_line)
      end)
    end

    # Return the new SocketInfo
    info
  end

  defp lookup(location, callback) do
    case Universa.Matter.Map.lookup(Universa.Matter.Map, location) do
      {:ok, pid} -> callback.(pid)
      :error -> {:error, :not_found}
    end
  end
end
