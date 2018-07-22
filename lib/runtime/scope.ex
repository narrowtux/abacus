defmodule Abacus.Runtime.Scope do
  @moduledoc """
  Contains helper functions to work with the scope of an Abacus script at runtime
  """

  @doc """
  Tries to get values from a subject.

  Subjects can be:

   * maps
   * keyword lists
   * lists (with integer keys)
   * nil (special case so access to undefined variables will not crash execution)

  Keys can be:

   * strings
   * atoms (you can pass a resolve map that converts the given atom key into a string key)
   * positive integers (for lists only)

  The Abacus parser will reference this function extensively like this:

  `a.b[2]` will turn into

  ```
  get_in(get_in(var0, :var1, var_lookup), 2, var_lookup)
  ```

  in this case, `var_lookup` will be:

  ```
  %{
    var1: "a",
    var2: "b"
  }
  ```
  """
  @type key :: String.t | atom
  @type index :: integer
  @spec get_in(nil, key | index, map) :: nil
  @spec get_in(map, key, map) :: nil | term
  @spec get_in(list, index, map) :: nil | term
  @spec get_in(list, key, map) :: nil | term
  def get_in(subject, key_or_index, var_lookup \\ %{})
  def get_in(nil, _, _), do: nil
  def get_in(subject, key, lookup) when is_atom(key) do
    key = Map.get(lookup, key, to_string(key))
    get_in(subject, key, lookup)
  end
  def get_in(subject, key, _) when (is_map(subject) or is_list(subject)) and is_binary(key) do
    Enum.reduce_while(subject, nil, fn {k, v}, _ ->
      case to_string(k) do
        ^key -> {:halt, v}
        _ -> {:cont, nil}
      end
    end)
  end
  def get_in(list, index, _) when is_list(list) and is_integer(index) and index >= 0 do
    Enum.at(list, index, nil)
  end
end
