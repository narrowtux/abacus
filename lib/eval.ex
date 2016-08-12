defmodule Abacus.Eval do
  def eval({:add, a, b}), do: eval(a) + eval(b)
  def eval({:subtract, a, b}), do: eval(a) - eval(b)
  def eval({:divide, a, b}), do: eval(a) / eval(b)
  def eval({:multiply, a, b}), do: eval(a) * eval(b)
  def eval({:power, a, b}), do: :math.pow(eval(a), eval(b))

  def eval({:function, "sin", [a]}), do: :math.sin(eval(a))

  def eval(number) when is_number(number), do: number

  def eval(expr), do: raise "can't evaluate the expression #{inspect expr}"
end
