defmodule Test.Parser.ParseTimeTest do
  use ExUnit.Case

  alias Lab42.F.SysInterface.Mock
  import Lab42.F.Parser, only: [parse: 1]
  import Test.Support.TimeHelper, only: [ntime: 6]

  setup do
    Mock.mock_now(ntime(2021, 2, 3, 4, 5, 6))
  end

  describe "absolute times" do
    test "completely specified" do
      parsed = parse(~W[ mlt 2021-01-31T12:13:14 ])
      assert parsed.mlt == ntime(2021, 1, 31, 12, 13, 14)
    end
    test "partially specified date → time gonna be midnight" do
      parsed = parse(~W[ mlt 2021-01-31 ])
      assert parsed.mlt == ntime(2021, 1, 31, 0, 0, 0)
    end

    test "partially specified time → date is from today" do
      parsed = parse(~W[ mgt 12:13 ])
      assert parsed.mgt == ntime(2021, 2, 3, 12, 13, 0)
    end
  end

  describe "relative times" do
    test "1 day ago" do
      parsed = parse(~W[ mgt 1_day_ago ])
      assert parsed.mgt == ntime(2021, 2, 2, 4, 5, 6)
    end
  end

  describe "timestamps from files" do
    test "from fixtures/doc1.txt" do
      parsed = parse(~W[ mgt test/fixtures/doc1.txt ])
      {{y, mth, d}, {h, min, s}} = File.lstat!("test/fixtures/doc1.txt").mtime
      assert parsed.mgt == ntime(y, mth, d, h, min, s)
    end
  end
end
