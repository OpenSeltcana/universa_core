defmodule Universa.Network.Account.Importer do
  @moduledoc """
  This module imports the old state of an Account (a logged-in player) from long term storage to memory and back.
  """

  @doc "Moves an account from long term storage to memory."
  def load(account_name) do
    # TODO: Actually load rooms from somewhere
    {:ok, %Universa.Network.Account.Info{
                    name: account_name,
                    locations: %{"1ebd411d-35d3-43cf-90eb-ceb547884e2d" => nil}}}
  end

  @doc "Moves an account from memory to long term storage."
  def save(_account_name) do
    # TODO: Actually store changes
  end
end
