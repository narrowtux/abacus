defmodule Abacus do
  def eval(expr) do
    eval(expr, %{})
  end

  def eval!(expr) do
    eval!(expr, %{})
  end

  def eval!(string, scope) when is_binary(string) or is_bitstring(string) do
    {:ok, expr} = parse(string)
    eval!(expr, scope)
  end

  def eval!(expr, scope) do
    Abacus.Eval.eval(expr, scope) 
  end

  def eval(string, scope) when is_binary(string) or is_bitstring(string) do
    case parse(string) do
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

  def format(string) when is_binary(string) or is_bitstring(string) do
    case parse(string) do
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

  def parse(string) do
    {:ok, tokens} = lex(string)
    :math_term_parser.parse(tokens)
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
