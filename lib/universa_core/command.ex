defmodule Universa.Core.Command do
  @moduledoc """
  This module marks a module as a `Command` to be used for the YAML importer.

  ## Example Usage

  At the top of your module add the following two lines:
  ```
    use Universa.Core.Command
    @command_key "test"
  ```
  to have the line `test: "A test"` passed to your `Component.new/1` function.
  """
  # A little hack to convert @component_key to a function (because attributes
  # are gone after compile, functions arent)

  defmacro __using__(_options) do
    quote location: :keep do
      Module.register_attribute(__MODULE__, :command_key, [])
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def command_key do
        @command_key
      end
    end
  end
end
