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
  @callback calculate(String.t(), Processor.t()) :: Processor.t()
end
