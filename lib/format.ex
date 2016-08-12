defmodule Abacus.Format do
  def format(number) when is_integer(number), do: Integer.to_string(number)
  def format(number) when is_float(number), do: Float.to_string(number)

  def format({operator, a, b}) when operator in [:add, :subtract, :divide, :multiply, :power] do
    op_string = case operator do
      :add -> "+"
      :subtract -> "-"
      :divide -> "/"
      :multiply -> "*"
      :power -> "^"
    end

    "#{format a} #{op_string} #{format b}"
  end

  def format({:function, name, arguments}) do
    arguments = arguments
    |> Enum.map(&format/1)
    |> Enum.join(", ")

    "#{name}(#{arguments})"
  end

  def format({:variable, name}), do: name
end
