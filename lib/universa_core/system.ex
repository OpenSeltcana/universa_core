defmodule Universa.Core.System do
  defmacro __using__(_options) do
    quote location: :keep do
      Module.register_attribute(__MODULE__, :command_key, [])
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def subscribe_to_components do
        @subscribe_to_components
      end

      # Catch_all to avoid errors when not subscribed
      def handle(_, _, _), do: nil
    end
  end

  defmacro subscribe(components) do
    quote do
      subscribe = case is_list(unquote(components)) do
        true -> unquote(components)
        false -> [unquote(components)]
      end
      @subscribe_to_components subscribe
    end
  end
end
