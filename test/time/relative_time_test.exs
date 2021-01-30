defmodule Test.Time.RelativeTimeTest do
  use ExUnit.Case
  alias Lab42.F.SysInterface.Mock
  import Lab42.F.Time, only: [make_time: 1]
  alias Test.Support.TimeHelper, as: H

  describe "now" do
    setup do
      Mock.mock_now(H.ntime(2021, 1, 1, 21, 39, 16))
    end
    test "1 day ago" do
      result = make_time("1_day_ago")
      expected = H.ntime(2020, 12, 31, 21, 39, 16)

      assert result == expected
    end

    test "3 minutes ago" do
      result = make_time("3_minutes_ago")
      expected = H.ntime(2021, 1, 1, 21, 36, 16)

      assert result == expected
    end

    test "an hour ago" do
      result = make_time("1_hour_ago")
      expected = H.ntime(2021, 1, 1, 20, 39, 16)

      assert result == expected
    end

    test "short syntax for day" do
      result = make_time("-2d")
      expected = H.ntime(2020, 12, 30, 21, 39, 16)

      assert result == expected
    end
  end

  describe "illegal syntax" do
    test "raises an appropriate error" do
      assert_raise( Lab42.F.Error, "illegal number 3_days_later", fn ->
        make_time("3_days_later")
      end)
    end
    test "which can be more specific" do
      assert_raise( Lab42.F.Error, "illegal relative time unit: dyas", fn ->
        make_time("3_dyas_ago")
      end)
      
    end
  end
end
