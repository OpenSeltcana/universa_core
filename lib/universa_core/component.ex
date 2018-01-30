defmodule Universa.Core.Component do
  @moduledoc """
  This module marks a module as a `Component` to be used for the YAML importer.

  ## Example Usage

  At the top of your module add the following two lines:
  ```
    use Universa.Core.Component
    @type "name"
    @value "Unknown"
  ```
  to have the line `test: "A test"` passed to your `Component.new/1` function.
  """
  # A little hack to convert @component_key to a function (because attributes
  # are gone after compile, functions arent)

  @callback new() :: any

  defmacro __using__(_options) do
    quote location: :keep do
      Module.register_attribute(__MODULE__, :component_key, [])
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      defstruct @component_value

      def component_type do
        @component_type
      end

      def new(value) do
        if is_map(value) do
          struct(__MODULE__, value)
        else
          value
        end
      end
    end
  end
end
