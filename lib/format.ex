defmodule Abacus.Format do
  @basic_operators [:add, :subtract, :divide, :multiply, :power]

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
    with_parantheses = "!(#{a})"
    without_parantheses = "!#{a}"

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
    end
  end

  def format({:variable, name}), do: name
end
