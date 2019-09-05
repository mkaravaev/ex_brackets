defmodule ExBrackets.File do
  @behaviour ExBrackets.Processor

  alias ExBrackets.Processor

  #Just random number to emulate batch processing for large files
  @chars_number 64

  @impl Processor
  def success_response(count) do
    {count, count}
  end

  @impl Processor
  def failed_response(count) do
    {:halt, count}
  end

  @impl Processor
  def process(path) do
    File.stream!(path, [], @chars_number)
    |> Stream.transform(
      %Processor{},
      &Processor.calculate(&1, &2, __MODULE__)
    )
    |> Enum.into(%{})
  end
end

