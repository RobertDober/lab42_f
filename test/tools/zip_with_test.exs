defmodule Test.Tools.ZipWithTest do
  use ExUnit.Case
  import Lab42.F.Tools, only: [zip_with: 2, zip_with: 3]

  describe "zip with" do
    test "it runs to the longest and uses id by default" do
      assert zip_with([1, 2, 3], ["a", "b"]) == [{1, "a"}, {2, "b"}, {3, nil}] 
    end
    test "it runs to the longest and uses id by default -- symetric case" do
      assert zip_with([1, 2], ["a", "b", "c"]) == [{1, "a"}, {2, "b"}, {nil, "c"}] 
    end
    test "it applies the zip function on all elements" do
      result = zip_with([1, 2, 3], [10, 20], fn {x, y} -> (x || 0) + (y || 0) end)
      expected = [11, 22, 3]
      assert result == expected
    end
  end
end
