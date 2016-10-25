defmodule Abacus.Compile do
  @conversion [
    add: :+,
    subtract: :-,
    divide: :/,
    multiply: :*,
    logical_and: :&&,
    logical_or: :||,
    eq: :==,
    neq: :!=,
    gt: :>,
    lt: :<,
    gte: :>=,
    lte: :<=,
  ]

  for {abacus, elixir} <- @conversion do
    def compile({unquote(abacus), a, b}) do
      {:ok, {
        unquote(elixir),
        [],
        [a, b]}}
    end
  end

  def compile(num) when is_number(num), do: {:ok, num}
  def compile(other) when other in [true, false, nil], do: {:ok, other}
end
