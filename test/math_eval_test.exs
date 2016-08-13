defmodule MathEvalTest do
  use ExUnit.Case
  doctest Abacus.Eval

  describe "The eval module should evaluate" do
    test "basic arithmetic" do
      assert {:ok, 1 + 2} = Abacus.eval("1 + 2")

      assert {:ok, 10 * 10} = Abacus.eval("10 * 10")

      assert {:ok, 20 * (1 + 2)} = Abacus.eval("20 * (1 + 2)")
    end

    test "function calls" do
      assert {:ok, :math.sin(90)} == Abacus.eval("sin(90)")
      assert {:ok, Float.round(512.4122, 2)} == Abacus.eval("round(512.4122, 2)")
    end

    test "error" do
      assert {:error, _} = Abacus.eval("undefined_function()")
    end

    test "scoped variables" do
      assert {:ok, 8} = Abacus.eval("a + 3", %{"a" => 5})
    end

    test "factorial" do
      assert {:ok, 3628800} == Abacus.eval("!(5 * 2)")
    end
  end
end
