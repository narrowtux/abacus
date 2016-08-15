defmodule FormatTest do
  use ExUnit.Case
  doctest Abacus.Format
  import Abacus, only: [format: 1]

  describe "should format" do
    test "basic operators" do
      assert format("a + b") == {:ok, "a + b"}
      assert format("1 - b") == {:ok, "1 - b"}
      assert format("1 / b") == {:ok, "1 / b"}
      assert format("1 * b") == {:ok, "1 * b"}
      assert format("1^b") == {:ok, "1 ^ b"}
    end

    test "grouping" do
      assert format("2 - (2 - 3)") == {:ok, "2 - (2 - 3)"}
      assert format("2 + (2 + 2)") == {:ok, "2 + (2 + 2)"}
      assert format("(2 + 2) + 2") == {:ok, "2 + 2 + 2"}
      assert format("(1 + 2) * (3 - 4)") == {:ok, "(1 + 2) * (3 - 4)"}
    end

    test "functions" do
      assert format("sin(2)") == {:ok, "sin(2)"}
      assert format("function_with_arguments(1, 2, (2 + 3))") == {:ok, "function_with_arguments(1, 2, 2 + 3)"}
    end

    test "advanced operators" do
      assert format("10!") == {:ok, "10!"}
      assert format("2!-2") == {:ok, "2! - 2"}
      assert format("(2+2)!") == {:ok, "(2 + 2)!"}
    end

    test "advanced variable expressions" do
      assert format("a.b.c") == {:ok, "a.b.c"}
      assert format("a[1+b+c]") == {:ok, "a[1 + b + c]"}
      assert format("a.b[i]") == {:ok, "a.b[i]"}
    end

    test "bitwise operators" do
      assert format("a & b") == {:ok, "a & b"}
      assert format("a | b") == {:ok, "a | b"}
      assert format("a |^ b") == {:ok, "a |^ b"}
      assert format("~ 10") == {:ok, "~10"}
      assert format("1 <<8") == {:ok, "1 << 8"}
      assert format("32>>4") == {:ok, "32 >> 4"}
    end
  end
end
