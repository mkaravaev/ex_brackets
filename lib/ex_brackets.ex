defmodule ExBrackets do
  @moduledoc """
  Documentation for ExBrackets.
  """


  def check(str) when is_binary(str) do
    str
    |> String.codepoints()
    |> _check({0, 0})
  end
  def check(_), do: false

  defp _check([")" | _], {0, 0}), do: false
  defp _check(["(" | tail], {0, 0}) do
    _check(tail, {1, 0})
  end

  defp _check([head | tail], {open, closed} = state) when open >= 1 do
    case head do
      "(" -> _check(tail, {open+1, closed})
      ")" -> _check(tail, {open, closed+1})
      _ -> _check(tail, state)
    end
  end
  defp _check([], {open, closed}) do
    open == closed
  end

end
