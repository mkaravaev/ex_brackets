defmodule ExBrackets.String do
  @behaviour ExBrackets.Processor

  alias ExBrackets.Processor

  @impl Processor
  def success_response(count), do: count

  @impl Processor
  def failed_response(count), do: count

  @impl Processor
  def process(str) do
    Processor.calculate(str, %Processor{}, __MODULE__)
  end
end
