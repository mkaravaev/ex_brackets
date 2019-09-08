defimpl Enumerable, for: ExBrackets.Processor do
  def count(map) do
    {:ok, map_size(map)}
  end

  def member?(map, {key, value}) do
    {:ok, match?(%{^key => ^value}, map)}
  end

  def member?(_map, _other) do
    {:ok, false}
  end

  def slice(map) do
    {:ok, map_size(map), &Enumerable.List.slice(:maps.to_list(map), &1, &2)}
  end

  def reduce(map, acc, fun) do
    reduce_list(:maps.to_list(map), acc, fun)
  end

  defp reduce_list(_list, {:halt, acc}, _fun), do: {:halted, acc}
  defp reduce_list(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce_list(list, &1, fun)}
  defp reduce_list([], {:cont, acc}, _fun), do: {:done, acc}
  defp reduce_list([head | tail], {:cont, acc}, fun), do: reduce_list(tail, fun.(head, acc), fun)
end

defmodule ExBrackets.Processor do

  @type t :: %__MODULE__{}
  defstruct [open_count: 0, closed_count: 0]

  @callback process(String.t()) :: Processor.t()
  @callback success_response(Processor.t()) :: any()
  @callback failed_response(Processor.t()) :: any()

  def calculate(str, count \\ %__MODULE__{}, mod)
  def calculate(str, count, mod) when is_binary(str) do
    str
    |> String.codepoints()
    |> _calculate(count, mod)
  end
  def calculate(_, count, mod), do: mod.failed_response(count)

  defp _calculate([], %{open_count: 0} = count, mod) do
    mod.failed_response(count)
  end

  defp _calculate([], count, mod) do
    mod.success_response(count)
  end

  defp _calculate(_, %{open_count: open, closed_count: closed} = count, mod) when open < closed, 
    do: mod.failed_response(count)

  defp _calculate([head | tail], count, mod) do
    case head do
      "(" -> _calculate(tail, add_map(count, :open_count), mod)
      ")" -> _calculate(tail, add_map(count, :closed_count), mod)
      _ -> _calculate(tail, count, mod)
    end
  end

  defp add_map(count, key) do
    Map.update!(count, key, &(&1+1))
  end

end
