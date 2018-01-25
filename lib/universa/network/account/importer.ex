defmodule Universa.Network.Account.Importer do
  @moduledoc """
  This module imports the old state of an Account (a logged-in player) from long term storage to memory and back.
  """

  @doc "Moves an account from long term storage to memory."
  def load(account_name) do
    # TODO: Actually load rooms from somewhere
    case account_name do
      _ -> {:ok, %Universa.Network.Account.Info{name: account_name, locations: ["1"]}}
    end
  end

  @doc "Moves an account from memory to long term storage."
  def save(account_name) do
    # TODO: Actually store changes
  end
end
