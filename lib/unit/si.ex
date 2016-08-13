defmodule Abacus.Unit.SI do
  def prefix(prefix) do
    case prefix do
      "Y" -> :yotta
      "Z" -> :zetta
      "E" -> :exa
      "P" -> :peta
      "T" -> :tera
      "G" -> :giga
      "M" -> :mega
      "k" -> :kilo
      "h" -> :hecto
      "da" -> :deca

      "d" -> :deci
      "c" -> :centi
      "m" -> :milli
      "μ" -> :micro
      "n" -> :nano
      "p" -> :pico
      "f" -> :femto
      "a" -> :atto
      "z" -> :zepto
      "y" -> :yocto
    end
  end

  def short(prefix) do
    case prefix do
      :yotta -> "Y"
      :zetta -> "Z"
      :exa -> "E"
      :peta -> "P"
      :tera -> "T"
      :giga -> "G"
      :mega -> "M"
      :kilo -> "k"
      :hecto -> "h"
      :deca -> "da"

      :deci -> "d"
      :centi -> "c"
      :milli -> "m"
      :micro -> "μ"
      :nano -> "n"
      :pico -> "p"
      :femto -> "f"
      :atto -> "a"
      :zepto -> "z"
      :yocto -> "y"
    end
  end

  def expr(prefix) do
    {:power, 1000, case prefix do
      :yotta -> 8
      :zetta -> 7
      :exa -> 6
      :peta -> 5
      :tera -> 4
      :giga -> 3
      :mega -> 2
      :kilo -> 1
      :hecto -> {:divide, 2, 3}
      :deca -> {:divide, 1, 3}

      :deci -> {:divide, -1, 3}
      :centi -> {:divide, -2, 3}
      :milli -> -1
      :micro -> -2
      :nano -> -3
      :pico -> -4
      :femto -> -5
      :atto -> -6
      :zepto -> -7
      :yocto -> -8
    end}
  end

  def multiplier(prefix) do
    prefix
    |> expr
    |> Abacus.eval!
  end
end
