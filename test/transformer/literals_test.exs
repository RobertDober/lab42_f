defmodule Test.Transformer.LiteralsTest do
  use ExUnit.Case

  import Test.Support.Trans, only: [trans: 1]

  describe "space and end" do
    @files ~W[one two three]
    @trans "%s%e%s"

    test "  " do
      result = trans({@files, @trans})
      expected = ["  ", "  ", "  "]

      assert result == expected
    end
  end

  describe "space and percentage and %%b" do
    @files ~W[one two]
    test "%b" do
      result = trans({@files, "%s%%b"})
      expected = [" %b", " %b"]

      assert result == expected
    end
    test "%%b" do
      result = trans({@files, "%s%%%%b"})
      expected = [" %%b", " %%b"]

      assert result == expected
    end
  end
end
