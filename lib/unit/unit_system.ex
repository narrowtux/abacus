defmodule Abacus.UnitSystem do
  defmacro __using__(opts) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)

      @doc "Converts the given `value` from one unit to another"
      @spec convert(from::atom, to::atom, value::number) :: number

      @units []

    end
  end

  defmacro unit name, base, ratio, offset \\ 0 do
    quote do

      @units [unquote(name) | @units] |> Enum.uniq

      def convert(value, unquote(name) = _from, unquote(base) = _to) do
        (value + unquote(offset)) / unquote(ratio)
      end

      def convert(value, unquote(base) = _from, unquote(name) = _to) do
        value * unquote(ratio) - unquote(offset)
      end

      def base(unquote(name) = _of), do: unquote(base)
    end
  end

  defmacro convert_all do
    quote do
      def convert(value, from, to) do
        if base(from) == base(to) do
          base = base(from)

          value
          |> convert(from, base)
          |> convert(base, to)
        else
          raise "Incompatible base units"
        end
      end

      def units, do: @units

      def base(_), do: nil

      def deep_base(unit) do
        IO.puts unit
        case base(unit) do
          nil -> unit
          deeper -> deep_base(deeper)
        end
      end
    end
  end
end
