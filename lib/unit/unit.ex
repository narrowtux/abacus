defmodule Abacus.Unit do
  alias Abacus.Unit.SI
  defstruct [
    name: nil,
    dimensions: [0, 0, 0, 0, 0, 0, 0],

    friendly_short: nil,
    friendly_singular: nil,
    friendly_plural: nil,
    base_unit: nil,
    prefix: nil
  ]

  def meters do
    %__MODULE__{
      name: :meters,
      dimensions: [1, 0, 0, 0, 0, 0, 0],

      friendly_short: "m",
      friendly_singular: "meter",
      friendly_plural: "meters"
    }
  end

  def prefix(unit, prefix) do
    as_string = Atom.to_string(prefix)
    %{
      name: :"#{as_string}_#{unit.name}",
      dimensions: unit.dimensions,

      friendly_short: "#{SI.short(prefix)}#{unit.friendly_short}",
      friendly_singular: "#{as_string}#{unit.friendly_singular}",
      friendly_plural: "#{as_string}#{unit.friendly_plural}",
      base_unit: unit,
      prefix: prefix
    }
  end
end
