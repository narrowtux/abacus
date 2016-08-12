defmodule MathEvalTest do
  use ExUnit.Case
  doctest MathParser.Eval

  describe "The eval module should evaluate" do
    test "basic arithmetic" do
      assert {:ok, 1 + 2} = MathParser.eval("1 + 2")

      assert {:ok, 10 * 10} = MathParser.eval("10 * 10")

      assert {:ok, 20 * (1 + 2)} = MathParser.eval("20 * (1 + 2)")
    end

    test "function calls" do
      assert {:ok, :math.sin(90)} == MathParser.eval("sin(90)")
    end

    test "error" do
      assert {:error, _} = MathParser.eval("undefined_function()")
    end
  end
end
