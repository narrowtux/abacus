defmodule LambdaTest do
  use ExUnit.Case

  test "basic lambda parse" do
    code = ~s[
      (x, y) => {x * y}
    ]
  end

  test "basic lambda execution" do
    code = ~s[
      fun = (x, y) => {
        x > y ? x : y
      }
      fun(x, y)
    ]

    assert Abacus.eval(code, %{"x" => 2, "y" => 10})
  end
end
