defmodule Abacus.Eval do
  def eval({:add, a, b}, scope), do: eval(a, scope) + eval(b, scope)
  def eval({:subtract, a, b}, scope), do: eval(a, scope) - eval(b, scope)
  def eval({:divide, a, b}, scope), do: eval(a, scope) / eval(b, scope)
  def eval({:multiply, a, b}, scope), do: eval(a, scope) * eval(b, scope)
  def eval({:power, a, b}, scope), do: :math.pow(eval(a, scope), eval(b, scope))

  def eval({:function, "sin", [a]}, scope), do: :math.sin(eval(a, scope))
  def eval({:function, "cos", [a]}, scope), do: :math.cos(eval(a, scope))
  def eval({:function, "tan", [a]}, scope), do: :math.tan(eval(a, scope))

  def eval({:function, "floor", [a]}, scope), do: Float.floor(eval(a, scope))
  def eval({:function, "floor", [a, precision]}, scope), do: Float.floor(eval(a, scope), eval(precision, scope))

  def eval({:function, "ceil", [a]}, scope), do: Float.ceil(eval(a, scope))
  def eval({:function, "ceil", [a, precision]}, scope), do: Float.ceil(eval(a, scope), eval(precision, scope))

  def eval({:function, "round", [a]}, scope), do: Float.round(eval(a, scope))
  def eval({:function, "round", [a, precision]}, scope), do: Float.round(eval(a, scope), eval(precision, scope))

  def eval({:variable, name}, scope) do
    case Map.get(scope, name, nil) do
      nil -> raise "Value for key '#{name}' not found in scope (#{inspect scope})"
      number when is_number(number) -> number
      value -> raise "Value #{inspect value} has wrong type"
    end
  end

  def eval(number, _scope) when is_number(number), do: number

  def eval(expr), do: raise "can't evaluate the expression #{inspect expr}"
end
