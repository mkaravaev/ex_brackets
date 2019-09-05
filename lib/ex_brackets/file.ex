defmodule ExBrackets.File do
  @behaviour ExBrackets.Processor

  alias ExBrackets.Processor

  @count %Processor{}

  #Just random number to emulate batch processing for large files
  @chars_number 64

  @impl Processor
  def process(path) do
    File.stream!(path, [], @chars_number)
    |> Stream.transform(@count, &calculate/2)
    |> Enum.into(%{})
  end

  @impl Processor
  def calculate(str, count \\ @count) when is_binary(str) do
    str
    |> String.codepoints()
    |> _calculate(count)
  end
  def calculate(_, _), do: {:halt, @count}

  defp _calculate([], %{open_count: 0}), do: {:halt, @count}

  defp _calculate([], count), do: {count, count}

  defp _calculate([head | tail], %{open_count: 0} = count) do
    case head do
      "(" -> _calculate(tail, add_map(count, :open_count))
      ")" -> {:halt, @count}
      _ ->  _calculate(tail, count)
    end
  end

  defp _calculate([head | tail], %{open_count: open} = count) when open >= 1 do
    case head do
      "(" -> _calculate(tail, add_map(count, :open_count))
      ")" -> _calculate(tail, add_map(count, :closed_count))
      _ -> _calculate(tail, count)
    end
  end

  defp add_map(count, key) do
    Map.update!(count, key, &(&1+1))
  end

end

