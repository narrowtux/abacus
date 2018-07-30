defmodule Abacus.Runtime.Helpers do
  def cast_for_comparison(atom) when is_atom(atom) do
    to_string(atom)
  end
  def cast_for_comparison(other) do
    other
  end

  @moduledoc """
  Utility functions
  """

  @doc """
  Returns the factorial of n.

  ## Example

  ```
  iex(2)> factorial(0)
  1
  iex(3)> factorial(1)
  1
  iex(4)> factorial(2)
  2
  iex(5)> factorial(3)
  6
  iex(6)> factorial(4)
  24
  iex(7)> factorial(5)
  120
  ```
  """
  @spec factorial(number) :: number
  def factorial(0), do: 1
  def factorial(n) when n > 0 do
    _factorial(1, n, 1)
  end

  def _factorial(n, m, r) when n < m do
     _factorial(n + 1, m, r * (n + 1))
  end

  def _factorial(n, n, r), do: r
end
