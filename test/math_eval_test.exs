defmodule MathEvalTest do
  use ExUnit.Case

  describe "The eval module should evaluate" do
    test "basic arithmetic" do
      assert {:ok, 1 + 2} == Abacus.eval("1 + 2")

      assert {:ok, 10 * 10} == Abacus.eval("10 * 10")

      assert {:ok, 20 * (1 + 2)} == Abacus.eval("20 * (1 + 2)")
    end

    test "function calls" do
      assert {:ok, :math.sin(90)} == Abacus.eval("sin(90)")
      assert {:ok, Float.round(512.4122, 2)} == Abacus.eval("round(512.4122, 2)")
      assert {:ok, 2} == Abacus.eval("log10(100)")
    end

    test "error" do
      assert {:error, _} = Abacus.eval("undefined_function()")
      assert {:error, _} = Abacus.eval("1.")
    end

    test "scoped variables" do
      assert {:ok, 8} = Abacus.eval("a + 3", %{"a" => 5})
    end

    test "factorial" do
      assert {:ok, 3628800} == Abacus.eval("(5 * 2)!")
    end

    test "variables" do
      assert {:ok, 10} == Abacus.eval("a.b.c[1]", %{
        "a" => %{
          "b" => %{
            "c" => [
              1,
              10,
              -42
            ]
          }
        }
        })
    end

    test "variable in index expression" do
      assert {:ok, 10} == Abacus.eval("list[a]", %{
        "list" => [1, 2, 3, 10, 5],
        "a" => 3
        })
    end

    test "bitwise operators" do
      import Bitwise
      assert {:ok, 1 &&& 2} == Abacus.eval("1 & 2")
      assert {:ok, 3 ||| 4} == Abacus.eval("3 | 4")
      assert {:ok, bxor(1, 2)} == Abacus.eval("1 |^ 2")
      assert {:ok, ~~~10} == Abacus.eval("~10")
      assert {:ok, 1 <<< 8} == Abacus.eval("1 << 8")
      assert {:ok, 32 >>> 2} == Abacus.eval("32 >> 2")
    end

    test "ternary operator" do
      assert {:ok, 42} == Abacus.eval("1 == 1 ? 42 : 0")
      assert {:ok, 42} == Abacus.eval("1 == 2 ? 0 : 42")
    end

    test "reserved words" do
      assert {:ok, true} == Abacus.eval("true")
      assert {:ok, false} == Abacus.eval("false")
      assert {:ok, nil} == Abacus.eval("null")
    end

    test "comparison" do
      assert {:ok, true} = Abacus.eval("42 > 10")
      assert {:ok, true} = Abacus.eval("42 >= 10")
      assert {:ok, false} = Abacus.eval("42 < 10")
      assert {:ok, true} = Abacus.eval("10 < 42")
      assert {:ok, false} = Abacus.eval("42 == 10")
      assert {:ok, true} = Abacus.eval("42 != 10")
      assert {:ok, false} = Abacus.eval("10 != 10")
      assert {:ok, true} = Abacus.eval(~s["a" == "a"])
      assert {:ok, true} = Abacus.eval(~s["a" == a], %{"a" => "a"})
      assert {:ok, true} = Abacus.eval("\"a\\\"b\" == a", %{"a" => "a\"b"})
      assert {:ok, true} = Abacus.eval("a == b", %{"a" => :foo, "b" => "foo"})
      assert {:ok, true} = Abacus.eval("a == b", %{"a" => "foo", "b" => :foo})
      assert {:ok, true} = Abacus.eval("a == b", %{"a" => :foo, "b" => :foo})
      assert {:ok, true} = Abacus.eval("a == b", %{"a" => "foo", "b" => "foo"})
      assert {:ok, true} = Abacus.eval("\"foo\" == b", %{"b" => :foo})
      assert {:ok, true} = Abacus.eval("\"🤓\" == b", %{"b" => "🤓"})
      assert {:ok, false} = Abacus.eval("a == b", %{"a" => :foo, "b" => :bar})
    end

    test "comparison of different types" do
      assert {:ok, false} = Abacus.eval("a.b > 30", %{a: %{}})
      assert {:ok, false} = Abacus.eval("a.b < 30", %{a: %{}})
      assert {:ok, false} = Abacus.eval("null > 30")
      assert {:ok, false} = Abacus.eval("null <= 30")
      assert {:ok, false} = Abacus.eval("false >= 30")
      assert {:ok, true} = Abacus.eval("null == null")
      assert {:ok, true} = Abacus.eval("null != 30")
      assert {:ok, true} = Abacus.eval("a == b", %{a: 30, b: 30.0})
      assert {:ok, true} = Abacus.eval("a == b", %{a: "abc", b: :abc})
    end

    test "default scope injection" do
      assert {:ok, 1.0} == Abacus.eval("cos(2 * PI)")
      assert {:ok, 0.0} == Abacus.eval("sin(0)")
    end

    test "invalid boolean arithmetic" do
      assert {:error, _} = Abacus.eval("false + 1")
    end

    test "unexpected token" do
      assert {:error, _} = Abacus.eval("1 + )")
    end
  end
end
