defmodule Test.Transformer.BasenameTest do
  use ExUnit.Case

  import Lab42.F.Transformer, only: [transform: 1]

  describe "basename" do
    @files ~W[a/none b/base.ex c/readme.md.eex]

    test "with all extensions" do
      result = transform({@files, "%b"})
      expected = ~W[none base.ex readme.md.eex]

      assert result == expected
    end

    test "w/o last extension" do
      result = transform({@files, "%bx"})
      expected = ~W[none base readme.md]

      assert result == expected
    end

    test "w/o any extension" do
      result = transform({@files, "%bX"})
      expected = ~W[none base readme]

      assert result == expected
    end
  end

  describe "dirnames" do
    @files ~W[a/b/c d/e f]
    test "relative dirname" do
      result = transform({@files, "%d"})
      expected = ~W[a/b d .]

      assert result == expected
      
    end

    test "absolute dirname" do
      result = transform({@files, "%D"})
      expected = ~W[/abspath/a/b /abspath/d /abspath]

      assert result == expected
    end
  end

  describe "extensions" do
    @files ~W[a b.c d.e.f]

    test "last extension" do
      result = transform({@files, "%x"})
      expected = ["", ".c", ".f"] 

      assert result == expected
    end

    test "all extensions" do
      result = transform({@files, "%X"})
      expected = ["", ".c", ".e.f"] 

      assert result == expected
    end
  end
end
