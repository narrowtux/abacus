defmodule Abacus do
  @moduledoc """
  A math-expression parser, evaluator and formatter for Elixir.

  ## Features

  ### Supported operators

   - `+`, `-`, `/`, `*`
   - Exponentials with `^`
   - Factorial (`n!`)
   - Bitwise operators
     * `<<` `>>` bitshift
     * `&` bitwise and
     * `|` bitwise or
     * `|^` bitwise xor
     * `~` bitwise not (unary)
   - Boolean operators
     * `&&`, `||`, `not`
     * `==`, `!=`, `>`, `>=`, `<`, `<=`
     * Ternary `condition ? if_true : if_false`

  ### Supported functions

   - `sin(x)`, `cos(x)`, `tan(x)`
   - `round(n, precision = 0)`, `ceil(n, precision = 0)`, `floor(n, precision = 0)`

  ### Reserved words

   - `true`
   - `false`
   - `null`

  ### Access to variables in scope

   - `a` with scope `%{"a" => 10}` would evaluate to `10`
   - `a.b` with scope `%{"a" => %{"b" => 42}}` would evaluate to `42`
   - `list[2]` with scope `%{"list" => [1, 2, 3]}` would evaluate to `3`

  If a variable is not in the scope, `eval/2` will result in `{:error, error}`.
  """

  @doc """
  Evaluates the given expression with no scope.

  If `expr` is a string, it will be parsed first.
  """
  @spec eval(expr::tuple | charlist | String.t) :: {:ok, result::number} | {:error, error::map}
  @spec eval(expr::tuple | charlist | String.t, scope::map) :: {:ok, result::number} | {:error, error::map}

  @spec eval!(expr::tuple | charlist | String.t) :: result::number
  @spec eval!(expr::tuple | charlist | String.t, scope::map) :: result::number
  def eval(expr) do
    eval(expr, %{})
  end

  @doc """
  Evaluates the given expression.

  Raises errors when parsing or evaluating goes wrong.
  """
  def eval!(expr) do
    eval!(expr, %{})
  end

  @doc """
  Evaluates the given expression with the given scope.

  If `expr` is a string, it will be parsed first.
  """
  def eval!(expr, scope) when is_binary(expr) or is_bitstring(expr) do
    {:ok, expr} = parse(expr)
    eval!(expr, scope)
  end

  def eval!(expr, scope) do
    Abacus.Eval.eval(expr, scope)
  end

  def eval(expr, scope) when is_binary(expr) or is_bitstring(expr) do
    case parse(expr) do
      {:ok, expr} ->
        eval(expr, scope)
      {:error, _} = error -> error
    end
  end

  def eval(expr, scope) do
    try do
      {:ok, Abacus.Eval.eval(expr, scope)}
    rescue
      error -> {:error, error}
    end
  end

  @spec format(expr :: tuple | String.t | charlist) :: {:ok, String.t} | {:error, error::map}
  @doc """
  Pretty-prints the given expression.

  If `expr` is a string, it will be parsed first.
  """
  def format(expr) when is_binary(expr) or is_bitstring(expr) do
    case parse(expr) do
      {:ok, expr} ->
        format(expr)
      {:error, _} = error -> error
    end
  end

  def format(expr) do
    try do
      {:ok, Abacus.Format.format(expr)}
    rescue
      error -> {:error, error}
    end
  end

  @spec parse(expr :: String.t | charlist) :: {:ok, expr::tuple} | {:error, error::map}
  @doc """
  Parses the given `expr` to a syntax tree.
  """
  def parse(expr) do
    {:ok, tokens} = lex(expr)
    :math_term_parser.parse(tokens)
  end

  def variables(expr) do
    Abacus.Tree.reduce(expr, fn
      {:access, variables} ->
        Enum.map(variables, fn
          {:variable, var} -> var
          {:index, index} -> variables(index)
        end)
        |> List.flatten
        |> Enum.uniq
      {_operator, a, b, c} ->
        Enum.concat([a, b, c])
        |> Enum.uniq
      {_operator, a, b} ->
        Enum.concat(a, b)
        |> Enum.uniq
      {_operator, a} -> a
      other -> []
    end)
  end

  defp lex(string) when is_binary(string) do
    string
    |> String.to_charlist
    |> lex
  end

  defp lex(string) do
    {:ok, tokens, _} = :math_term.string(string)
    {:ok, tokens}
  end
end
