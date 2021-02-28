defmodule Test.Transformer.PathTest do
  use ExUnit.Case

  import Lab42.F.Transformer, only: [transform: 1]
  
  describe "path" do
    @files ~W[x/a.b y/c.d]
    test "relative path" do
      result = transform({@files, "%p"})
      expected = @files

      assert result == expected
    end
    test "absolute path" do
      result = transform({@files, "%P"})
      expected = @files |>  Enum.map(&("/abspath/#{&1}"))

      assert result == expected
    end
  end

  describe "extensions" do
    @files ~W[a/none b/base.ex c/readme.md.eex]
    test "w/o last extension" do
      result = transform({@files, "%px"}) 
      expected = ~W[a/none b/base c/readme.md]

      assert result == expected
    end

    test "w/o any extension" do
      result = transform({@files, "%pX"}) 
      expected = ~W[a/none b/base c/readme]

      assert result == expected
    end

    test "full w/o last extension" do
      result = transform({@files, "%Px"}) 
      expected = ~W[/abspath/a/none /abspath/b/base /abspath/c/readme.md]

      assert result == expected
    end

    test "full w/o any extension" do
      result = transform({@files, "%PX"}) 
      expected = ~W[/abspath/a/none /abspath/b/base /abspath/c/readme]

      assert result == expected
    end
  end
end
