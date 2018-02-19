defmodule Abacus.Eval do
  @moduledoc """
  Function definitions on how to evaluate a syntax tree.

  You usually don't need to call `eval/2` yourself, use `Abacus.eval/2` instead.
  """

  use Bitwise
  alias Abacus.Util

  @spec eval(expr::tuple | number, scope::map) :: {:ok, result::number} | {:ok, boolean} | {:ok, nil} | {:error, term}

  # BASIC ARITHMETIC

  def eval({:add, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a + b}
  def eval({:subtract, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a - b}
  def eval({:divide, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a / b}
  def eval({:multiply, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a * b}

  # OTHER OPERATORS

  def eval({:power, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, :math.pow(a, b)}
  def eval({:factorial, a} , _)
    when is_number(a),
    do: {:ok, Util.factorial(a)}

  # COMPARISION

  def eval({:eq, a, b}, _),
    do: {:ok, a == b}
  def eval({:neq, a, b}, _),
    do: {:ok, a != b}

  def eval({:gt, a, b}, _),
    do: {:ok, a > b}
  def eval({:gte, a, b}, _),
    do: {:ok, a >= b}
  def eval({:lt, a, b}, _),
    do: {:ok, a < b}
  def eval({:lte, a, b}, _),
    do: {:ok, a <= b}

  # LOGICAL COMPARISION

  def eval({:logical_and, a, b}, _)
    when is_boolean(a) and is_boolean(b),
    do: {:ok, a && b}

  def eval({:logical_or, a, b}, _)
    when is_boolean(a) and is_boolean(b),
    do: {:ok, a || b}

  def eval({:logical_not, a}, _)
    when is_boolean(a),
    do: {:ok, not a}

  def eval({:ternary_if, condition, if_true, if_false}, _) do
    if condition do
      {:ok, if_true}
    else
      {:ok, if_false}
    end
  end

  # FUNCTIONS

  def eval({:function, "sin", [a]}, _)
    when is_number(a),
    do: {:ok, :math.sin(a)}
  def eval({:function, "cos", [a]}, _)
    when is_number(a),
    do: {:ok, :math.cos(a)}
  def eval({:function, "tan", [a]}, _)
    when is_number(a),
    do: {:ok, :math.tan(a)}

  def eval({:function, "floor", [a]}, _)
    when is_number(a),
    do: {:ok, Float.floor(a)}
  def eval({:function, "floor", [a, precision]}, _)
    when is_number(a) and is_number(precision),
    do: {:ok, Float.floor(a, precision)}

  def eval({:function, "ceil", [a]}, _)
    when is_number(a),
    do: {:ok, Float.ceil(a)}
  def eval({:function, "ceil", [a, precision]}, _)
    when is_number(a) and is_number(precision),
    do: {:ok, Float.ceil(a, precision)}

  def eval({:function, "round", [a]}, _)
    when is_number(a),
    do: {:ok, Float.round(a)}
  def eval({:function, "round", [a, precision]}, _)
    when is_number(a) and is_number(precision),
    do: {:ok, Float.round(a, precision)}

  def eval({:function, "log10", [a]}, _)
    when is_number(a),
    do: {:ok, :math.log10(a)}

  # IDENTITY

  def eval(number, _)
    when is_number(number),
    do: {:ok, number}
  def eval(reserved, _)
    when reserved in [nil, true, false],
    do: {:ok, reserved}
  def eval(string, _)
    when is_binary(string),
    do: {:ok, string}

  # ACCESS

  def eval({:access, _} = expr, scope) do
    eval expr, scope, scope
  end

  # BINARY OPERATORS

  def eval({:not, expr}, _)
    when is_number(expr),
    do: {:ok, bnot(expr)}
  def eval({:and, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, band(a, b)}
  def eval({:or, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, bor(a, b)}
  def eval({:xor, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, bxor(a, b)}

  def eval({:shift_right, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a >>> b}
  def eval({:shift_left, a, b}, _)
    when is_number(a) and is_number(b),
    do: {:ok, a <<< b}


  # CATCH-ALL
  # !!! write new evaluations above this definition !!!
  def eval(_expr, _scope), do: {:error, :einval}

  # SPECIAL HANDLING FOR ACCESS

  import Abacus.Tree, only: [reduce: 2]

  defp eval({:access, [{:variable, name} | rest]}, scope, root) do
    case Map.get(scope, name, nil) do
      nil -> {:error, :einkey}
      value ->
        eval({:access, rest}, value, root)
    end
  end

  defp eval({:access, [{:index, index} | rest]}, scope, root) do
    {:ok, index} = reduce(index, &eval(&1, root))
    case Enum.at(scope, index, nil) do
      nil -> {:error, :einkey}
      value ->
        eval({:access, rest}, value, root)
    end
  end

  defp eval({:access, []}, value, _root), do: {:ok, value}
end
