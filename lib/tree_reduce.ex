defmodule Abacus.Tree do
  @spec reduce(expr::term, fun::function) :: term
  @doc """
  Works like Enum.reduce, but for trees 🌲
  """

  def reduce({operator, a, b, c}, fun) do
    fun.({operator, reduce(a, fun), reduce(b, fun), reduce(c, fun)})
  end

  def reduce({operator, a, b}, fun) do
    fun.({operator, reduce(a, fun), reduce(b, fun)})
  end

  def reduce({:access, _} = expr, fun) do
    fun.(expr)
  end

  def reduce({operator, a}, fun) do
    fun.({operator, reduce(a, fun)})
  end

  def reduce(other, fun) when is_number(other) do
    fun.(other)
  end
end
