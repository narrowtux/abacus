defmodule Abacus do
  def eval(expr) do
    eval(expr, %{})
  end

  def eval(string, scope) when is_binary(string) do
    {:ok, expr} = string
    |> parse

    expr
    |> eval(scope)
  end

  def eval(charlist, scope) when is_bitstring(charlist) do
    {:ok, expr} = charlist
    |> parse

    expr
    |> eval(scope)
  end

  def eval(expr, scope) do
    try do
      {:ok, Abacus.Eval.eval(expr, scope)}
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
