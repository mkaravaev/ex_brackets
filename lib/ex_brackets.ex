defmodule ExBrackets do
  alias ExBrackets.{File, String}

  def file_balanced?(path) do
    path
    |> File.process()
    |> is_balanced?()
  end

  def string_balanced?(input) do
    input
    |> String.process()
    |> is_balanced?()
  end

  def is_balanced?(%{open_count: 0, closed_count: 0}), do: true
  def is_balanced?(%{open_count: open, closed_count: closed}) do
    open == closed
  end
end
