defmodule Abacus.Eval do
  alias Abacus.Util

  def eval({:add, a, b}, scope), do: eval(a, scope) + eval(b, scope)
  def eval({:subtract, a, b}, scope), do: eval(a, scope) - eval(b, scope)
  def eval({:divide, a, b}, scope), do: eval(a, scope) / eval(b, scope)
  def eval({:multiply, a, b}, scope), do: eval(a, scope) * eval(b, scope)
  def eval({:power, a, b}, scope), do: :math.pow(eval(a, scope), eval(b, scope))

  def eval({:factorial, a}, scope) do
    a = eval(a, scope)

    Util.factorial(a)
  end

  def eval({:function, "sin", [a]}, scope), do: :math.sin(eval(a, scope))
  def eval({:function, "cos", [a]}, scope), do: :math.cos(eval(a, scope))
  def eval({:function, "tan", [a]}, scope), do: :math.tan(eval(a, scope))

  def eval({:function, "floor", [a]}, scope), do: Float.floor(eval(a, scope))
  def eval({:function, "floor", [a, precision]}, scope), do: Float.floor(eval(a, scope), eval(precision, scope))

  def eval({:function, "ceil", [a]}, scope), do: Float.ceil(eval(a, scope))
  def eval({:function, "ceil", [a, precision]}, scope), do: Float.ceil(eval(a, scope), eval(precision, scope))

  def eval({:function, "round", [a]}, scope), do: Float.round(eval(a, scope))
  def eval({:function, "round", [a, precision]}, scope), do: Float.round(eval(a, scope), eval(precision, scope))

  def eval({:access, _} = expr, scope) do
    eval expr, scope, scope
  end

  def eval({:access, [{:variable, name} | rest]}, scope, root) do
    case Map.get(scope, name, nil) do
      nil -> raise "Key #{name} not found in #{inspect scope}"
      value ->
        eval({:access, rest}, value, root)
    end
  end

  def eval({:access, [{:index, index} | rest]}, scope, root) do
    index = eval(index, root)
    case Enum.at(scope, index, nil) do
      nil -> raise "Index #{index} not found in list #{inspect scope}"
      value ->
        eval({:access, rest}, value, root)
    end
  end

  def eval({:access, []}, value, root), do: value

  def eval(number, _scope) when is_number(number), do: number

  def eval(expr), do: raise "can't evaluate the expression #{inspect expr}"
end
