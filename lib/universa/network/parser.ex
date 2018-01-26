defmodule Universa.Network.Parser do
  @moduledoc """
  Converts input from a client into a common format for every parser.
  """

  @doc "Temporary way of solving the command problem."
  def parse(input_line, info, socket) do
    # TODO: Authentication

    # If we dont have an account yet, create one with the name the user inputted.
    if info == nil do
      {:ok, info} = Universa.Network.Account.Importer.load(String.trim(input_line))
      info = %{info | locations: Map.put(info.locations, "1ebd411d-35d3-43cf-90eb-ceb547884e2d", "test_entity_uuid") }

      # Now for every location we are in, create our player entity
      # TODO: Read the locations from info
      Universa.Matter.Map.create(Universa.Matter.Map, "1ebd411d-35d3-43cf-90eb-ceb547884e2d")
      lookup "1ebd411d-35d3-43cf-90eb-ceb547884e2d", fn pid ->
        Universa.Matter.Map.Location.spawn(pid, "test_entity_uuid", socket)
        entities = Universa.Matter.Map.Location.get(pid)
        # Test for my sanity, checking if it actually works
        Universa.Matter.Entity.System.run([Universa.Matter.System.SendLine], entities, %{message: "You entered the game"})
      end
    else
      # TODO: Read the locations from info
      IO.inspect info
      lookup("1ebd411d-35d3-43cf-90eb-ceb547884e2d", fn pid ->
        Universa.Matter.Map.Location.push_input(
              pid,
              Map.get(info.locations, "1ebd411d-35d3-43cf-90eb-ceb547884e2d"),
              String.trim(input_line))
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
