defmodule Test.TimeTest do
  use ExUnit.Case
  alias Lab42.F.SysInterface.Mock

  describe "mocking now" do
    @tag :meta
    @now "2021-01-01 21:39:16Z"
    test "can be done" do
      Mock.mock_now(@now)

      assert to_string(Lab42.F.Time.now) == @now
    end
  end

  describe "relative dates" do
  end
end
