defmodule Abacus do
  def eval(string) when is_binary(string) do
    {:ok, expr} = string
    |> parse

    expr
    |> eval
  end

  def eval(charlist) when is_bitstring(charlist) do
    {:ok, expr} = charlist
    |> parse

    expr
    |> eval
  end

  def eval(expr) do
    try do
      {:ok, Abacus.Eval.eval(expr)}
    rescue
      error -> {:error, error.message}
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
