defmodule ExBracketsTest do
  use ExUnit.Case
  @false_input [
        ")(abcdifghigklmonop)", 
        "(((abcdifghigklmonop))",
        "())",
        ")",
        ""
      ]

  @true_input [
    "(abcdifghigklmonop)",
    "(((abcdifghigklmonop)))",
    "()"
  ]

  describe "&string_balanced?/1" do
    test "should return true if balanced" do
      Enum.map(@true_input, &(
        assert ExBrackets.string_balanced?(&1) == true
      ))
    end

    test "should return false if unbalanced" do
      Enum.map(@false_input, &(
        assert ExBrackets.string_balanced?(&1) == false
      ))
    end
  end

  describe "&file_balanced?/1" do
    test "should process balanced string from file with true" do
      path = "./test/fixtures/test_stream"

      assert ExBrackets.file_balanced?(path) == true
    end

    test "should process unbalanced string from file with false" do
      path = "./test/fixtures/test_stream_false"

      assert ExBrackets.file_balanced?(path) ==false 
    end
  end

end
