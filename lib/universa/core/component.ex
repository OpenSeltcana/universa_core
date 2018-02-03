defmodule Universa.Core.Component do
	use Ecto.Schema

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
      def component_type do
        @component_type
      end

      def component_default_value do
        Enum.map(@component_value, fn {x, y} ->
          {Atom.to_string(x), y}
        end)
      end

      #TODO: Stop using defstruct, instead check ourselves
      def new(value) do
        if is_map(value) do
          map = value
          #TODO: String.to_atom is meh?
          |> Enum.map(fn {x, y} -> {x, y} end)
          |> Map.new
          Map.merge(component_default_value(), map)
        else
          %{"value" => value}
        end
      end
    end
  end

  defmacro type(type) do
    quote do
      @component_type unquote(type)
    end
  end

  defmacro value(value) do
    quote do
      case is_list(unquote(value)) do
        true -> @component_value unquote(value)
        false -> @component_value value: unquote(value)
      end
    end
  end

	schema "components" do
		field :type, 				:string
		field :entity_uuid, :string
		field :value, 			:map
		field :value_index, :map
	end

  @doc "Creates a `Ecto.Changeset` of changes to be pushed to the database."
  @spec changeset(map, map) :: Ecto.Changeset.t
  def changeset(component, params \\ %{}) do
    component
    |> Ecto.Changeset.cast(params, [:value])
  end
end
