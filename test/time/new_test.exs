defmodule Test.Time.NewTest do
  use ExUnit.Case
  alias Lab42.F.SysInterface.Mock
  import Lab42.F.Time, only: [new: 1]
  alias Test.Support.TimeHelper, as: H

  describe "now" do
    @now "2021-01-01 21:39:16Z"
    setup do
      Mock.mock_now(@now)
    end
  end
end
