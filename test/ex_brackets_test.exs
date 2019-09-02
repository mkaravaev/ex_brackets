defmodule ExBracketsTest do
  use ExUnit.Case

  describe "&check/1" do
    test "should return true if balanced" do
      str1 = "(abcdifghigklmonop)"
      str2 = "(((abcdifghigklmonop)))"

      assert ExBrackets.check(str1) == true
      assert ExBrackets.check(str2) == true
    end

    test "should return false if unbalanced" do
      str1 = ")(abcdifghigklmonop)"
      str2 = "(((abcdifghigklmonop))"
      assert ExBrackets.check(str1) == false
      assert ExBrackets.check(str2) == false
    end

  end

end