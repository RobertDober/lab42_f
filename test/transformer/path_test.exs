defmodule Test.Transformer.PathTest do
  use ExUnit.Case

  import Test.Support.Trans, only: [trans: 1]
  
  describe "path" do
    @files ~W[x/a.b y/c.d]
    test "relative path" do
      result = trans({@files, "%p"})
      expected = @files

      assert result == expected
    end
    test "absolute path" do
      result = trans({@files, "%P"})
      expected = @files |>  Enum.map(&("/abspath/#{&1}"))

      assert result == expected
    end
  end

  describe "extensions" do
    @files ~W[a/none b/base.ex c/readme.md.eex]
    test "w/o last extension" do
      result = trans({@files, "%px"}) 
      expected = ~W[a/none b/base c/readme.md]

      assert result == expected
    end

    test "w/o any extension" do
      result = trans({@files, "%pX"}) 
      expected = ~W[a/none b/base c/readme]

      assert result == expected
    end

    test "full w/o last extension" do
      result = trans({@files, "%Px"}) 
      expected = ~W[/abspath/a/none /abspath/b/base /abspath/c/readme.md]

      assert result == expected
    end

    test "full w/o any extension" do
      result = trans({@files, "%PX"}) 
      expected = ~W[/abspath/a/none /abspath/b/base /abspath/c/readme]

      assert result == expected
    end
  end
end
