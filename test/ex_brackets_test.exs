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

  describe "&check/1" do
    test "should return true if balanced" do
      Enum.map(@true_input, &(
        assert ExBrackets.check(&1) == true
      ))
    end

    test "should return false if unbalanced" do
      Enum.map(@false_input, &(
        assert ExBrackets.check(&1) == false
      ))
    end
  end

end
