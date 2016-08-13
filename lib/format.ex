defmodule Abacus.Format do
  @basic_operators [:add, :subtract, :divide, :multiply, :power]

  def format(number) when is_integer(number), do: Integer.to_string(number)
  def format(number) when is_float(number), do: Float.to_string(number)

  def format({operator1, {operator2, _, _} = a, b}) when operator1 in @basic_operators and
                                                         operator2 in @basic_operators do
    op_string = format(operator1)

    "(#{format a}) #{op_string} #{format b}"
  end

  def format({operator1, a, {operator2, _, _} = b}) when operator1 in @basic_operators and
                                                         operator2 in @basic_operators do
    op_string = format(operator1)

    "#{format a} #{op_string} (#{format b})"
  end

  def format({operator, a, b}) when operator in @basic_operators do
    op_string = format(operator)

    "#{format a} #{op_string} #{format b}"
  end

  def format({:function, name, arguments}) do
    arguments = arguments
    |> Enum.map(&format/1)
    |> Enum.join(", ")

    "#{name}(#{arguments})"
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
