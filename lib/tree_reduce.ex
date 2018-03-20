defmodule Abacus.Tree do
  @spec reduce(expr::term, fun::function) :: term
  @doc """
  Works like Enum.reduce, but for trees 🌲
  """

  def reduce({:function, name, args}, fun) do
    # reduce all arguments
    args
    |> Enum.reduce(%{ok: [], error: []}, fn arg, %{ok: oks, error: errors} ->
      case reduce(arg, fun) do
        {:ok, res} ->
          %{ok: [res | oks], error: errors}
        {:error, res} ->
          %{ok: oks, error: [res, errors]}
      end
    end)
    |> case do
      %{error: [], ok: args} ->
        fun.({:function, name, Enum.reverse(args)})
      %{error: errors} -> {:error, errors}
    end
  end

  def reduce({operator, a, b, c}, fun) do
    with {:ok, a} <- reduce(a, fun),
         {:ok, b} <- reduce(b, fun),
         {:ok, c} <- reduce(c, fun) do
      fun.({operator, a, b, c})
    end
  end

  def reduce({operator, a, b}, fun) do
    with {:ok, a} <- reduce(a, fun),
         {:ok, b} <- reduce(b, fun) do
      fun.({operator, a, b})
    end
  end

  def reduce({:access, _} = expr, fun) do
    fun.(expr)
  end

  def reduce({operator, a}, fun) do
    with {:ok, a} <- reduce(a, fun) do
      fun.({operator, a})
    end
  end

  def reduce(other, fun) when is_number(other) or other in [nil, true, false] or is_binary(other) do
    fun.(other)
  end
end
