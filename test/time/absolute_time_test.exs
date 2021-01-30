defmodule Test.Time.AbsoluteTimeTest do
  use ExUnit.Case
  alias Lab42.F.SysInterface.Mock
  import Lab42.F.Time, only: [make_time: 1]
  alias Test.Support.TimeHelper, as: H

  setup do
    Mock.mock_now(H.ntime(2021, 2, 3, 4, 5, 6))
  end

  describe "date only" do
    test "is completed with time" do
      result = make_time("2020-02-29")
      expected = H.ntime(2020,2, 29)

      assert result == expected
    end
    test "and current year" do
      result = make_time("02-28")
      expected = H.ntime(2021, 2, 28)

      assert result == expected
    end
    test "and current month and year" do
      result = make_time("27")
      expected = H.ntime(2021, 2, 27)

      assert result == expected
    end
  end

  describe "illegal syntax" do
    test "raises an appropriate error" do
      assert_raise( Lab42.F.Error, "illegal absolute time 2021-02-29", fn ->
        make_time("2021-02-29")
      end)
    end
  end
end
