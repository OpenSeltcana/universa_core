defmodule Universa.Core.Component do
  # A little hack to convert @component_key to a function (because attributes are gone after compile, functions arent)

  defmacro __using__(_options) do
    quote location: :keep do
      Module.register_attribute(__MODULE__, :component_key, [])
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def component_key do
        @component_key
      end
    end
  end
end
