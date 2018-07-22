defmodule Abacus.Util do
  @moduledoc """
  Utility functions
  """

  @doc """
  Returns the factorial of n.

  ## Example

  ```
  iex(2)> factorial(0)
  1
  iex(3)> factorial(1)
  1
  iex(4)> factorial(2)
  2
  iex(5)> factorial(3)
  6
  iex(6)> factorial(4)
  24
  iex(7)> factorial(5)
  120
  ```
  """
  @spec factorial(number) :: number
  def factorial(0), do: 1
  def factorial(n) when n > 0 do
    _factorial(1, n, 1)
  end

  def _factorial(n, m, r) when n < m do
     _factorial(n + 1, m, r * (n + 1))
  end

  def _factorial(n, n, r), do: r

  def compile_test(code) when is_binary(code) do
    code
    |> :erlang.binary_to_list()
    |> compile_test()
  end
  def compile_test(code) when is_list(code) do
    Process.put(:variables, %{})
    {:ok, tokens, _} = :math_term.string(code)
    {:ok, ast} = :new_parser.parse(tokens)
    vars = Process.get(:variables)
    {:ok, ast, vars}
  end

  def eval_test(code, scope \\ []) do
    {:ok, ast, vars} = compile_test(code)
    IO.inspect ast, label: "AST"
    scope = prepare_scope(scope, vars) |> IO.inspect(label: "bindings")
    Code.eval_quoted(ast, scope)
  end

  def prepare_scope(scope, lookup) when is_map(scope) or is_list(scope) do
    Enum.map(scope, fn
      {k, v} ->
        case Map.get(lookup, to_string(k)) do
          nil ->
            # will not be used anyway
            {k, v}
          varname ->
            {varname, v}
        end
      v ->
        v
    end)
  end
  def prepare_scope(primitive, _), do: primitive
end
