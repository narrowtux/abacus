defmodule Abacus.Util do
  def factorial(0), do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)
end
