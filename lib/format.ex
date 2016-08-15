defmodule Abacus.Format do
  @moduledoc """
  Function definitions on how to pretty-print expressions.

  See `Abacus.format/1` for more information.
  """

  @basic_operators [:add, :subtract, :divide, :multiply, :power, :and, :or, :xor, :shift_left, :shift_right]

  @spec format(expr::tuple | number) :: String.t
  def format(number) when is_integer(number), do: Integer.to_string(number)
  def format(number) when is_float(number), do: Float.to_string(number)

  def format({operator, a, b} = expr) when operator in @basic_operators do
    op_string = format(operator)

    lhs = format a
    rhs = format b

    without_parantheses = "#{lhs} #{op_string} #{rhs}"
    with_left_parantheses = "(#{lhs}) #{op_string} #{rhs}"
    with_right_parantheses = "#{lhs} #{op_string} (#{rhs})"
    with_both_parantheses = "(#{lhs}) #{op_string} (#{rhs})"

    result = {
      Abacus.parse(without_parantheses),
      Abacus.parse(with_left_parantheses),
      Abacus.parse(with_right_parantheses),
      Abacus.parse(with_both_parantheses)
    }

    case result do
      {{:ok, ^expr}, _, _, _} -> without_parantheses
      {_, {:ok, ^expr}, _, _} -> with_left_parantheses
      {_, _, {:ok, ^expr}, _} -> with_right_parantheses
      {_, _, _, {:ok, ^expr}} -> with_both_parantheses
    end
  end

  def format({:function, name, arguments}) do
    arguments = arguments
    |> Enum.map(&format/1)
    |> Enum.join(", ")

    "#{name}(#{arguments})"
  end

  def format({:factorial, a} = expr) do
    a = format a
    with_parantheses = "(#{a})!"
    without_parantheses = "#{a}!"

    result = {
      Abacus.parse(without_parantheses),
      Abacus.parse(with_parantheses)
    }

    case result do
      {{:ok, ^expr}, _} -> without_parantheses
      {_, {:ok, ^expr}} -> with_parantheses
    end
  end

  def format({:not, a} = expr) do
    a = format a
    with_parantheses = "~(#{a})"
    without_parantheses = "~#{a}"

    result = {
      Abacus.parse(without_parantheses),
      Abacus.parse(with_parantheses)
    }

    case result do
      {{:ok, ^expr}, _} -> without_parantheses
      {_, {:ok, ^expr}} -> with_parantheses
    end
  end

  def format(operator) when operator in @basic_operators do
    case operator do
      :add -> "+"
      :subtract -> "-"
      :divide -> "/"
      :multiply -> "*"
      :power -> "^"
      :and -> "&"
      :or -> "|"
      :xor -> "|^"
      :shift_left -> "<<"
      :shift_right -> ">>"
    end
  end

  def format({:access, [{:variable, name} | rest]}) do
    case rest do
      [] -> name
      [{:index, _} | _] -> "#{name}#{format {:access, rest}}"
      [{:variable, _} | _] -> "#{name}.#{format {:access, rest}}"
    end
  end

  def format({:access, [{:index, expr} | rest]}) do
    case rest do
      [] -> "[#{format expr}]"
      [{:index, _} | _] -> "[#{format expr}]#{format {:access, rest}}"
      [{:variable, _} | _] -> "[#{format expr}].#{format {:access, rest}}"
    end
  end
end
