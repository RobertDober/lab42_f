defmodule Test.Transformer.ContextPatternsTest do
  use ExUnit.Case

  alias Lab42.F.SysInterface.Mock
  import Test.Support.Trans, only: [trans: 1]
  
  @files ["sentiel"]

  describe "random" do
    test "%rx10" do
      rb = Mock.mock_random_byte
      result = t("%rxhello%rx")
      expected = [r(rb, 4) <> "hello" <> r(rb, 4)]

      assert result == expected
    end
  end

  defp t(transform), do: trans({@files, transform})
  defp r(value, times) do
    value
    |> Stream.iterate(fn _ -> value end)
    |> Enum.take(times)
    |> Enum.join
  end
end
