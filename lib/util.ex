defmodule Abacus.Util do
  def factorial(0), do: 1
  def factorial(n) when n > 0 do
    _factorial(1, n, 1)
  end

  def _factorial(n, m, r) when n < m do
     _factorial(n + 1, m, r * (n + 1))
  end

  def _factorial(n, n, r), do: r
end
