defmodule MathParserTest do
  use ExUnit.Case
  doctest MathParser

  test "the lexer" do
    assert [
      {:number, _, 1},
      {:+, _},
      {:number, _, 1}
    ] = lex_term("1+1")

    assert [
      {:"(", _},
      {:number, _, 3.2},
      {:+, _},
      {:number, _, 4},
      {:")", _}
    ] = lex_term("(3.2 + 4)")
  end

  describe "the parser" do
    test "basic operators" do
      assert {:add, 1, 3} = parse_term("1+3")
      assert {:subtract, 50, 10} = parse_term("50- 10")
    end

    test "precedence and association" do
      assert {:add, {:add, 1, 1}, 1.2} =
        parse_term("1 + 1 + 1.2")

      assert {:add, {:add, 1, {:power, 3, 1}}, 1} =
        parse_term("1 + 3 ^ 1 + 1")
    end

    test "parantheses" do
      assert {:add, 1, {:add, 1, 3}} =
        parse_term("1 + (1 + 3)")

      assert {:add, 1, 1} =
        parse_term("((((((((((((((((1)))))))))))))))) + 1")
    end

    test "functions" do
      assert {:function, "sin", [90]} =
        parse_term("sin(90)")

      assert {:function, "max", [1, 3]} =
        parse_term("max(1, 3)")

      assert {:function, "cos", [{:multiply, 45, 2}]} =
        parse_term("cos(45 * 2)")
    end
  end

  def parse_term(string) do
    {:ok, result} = string
    |> lex_term
    |> :math_term_parser.parse

    result
  end

  def lex_term(string) when is_binary(string) do
    string
    |> String.to_charlist
    |> lex_term
  end

  def lex_term(string) do
    {:ok, tokens, _} = :math_term.string(string)
    tokens
  end
end
