defmodule Test.Acceptance.TimeFilterTest do
  use ExUnit.Case

  alias Lab42.F.SysInterface.Mock
  alias Test.Support.TimeHelper, as: H

  import Lab42.F, only: [run: 1]

  # @all_files ~W[
  #   video1.m4v video3.mpg video4.flv video5.avi pic1.jpg pic3.png doc1.txt doc2.doc doc3.pdf doc4.md doc5.csv video2.mp4 pic2.JPEG
  # ]

  describe "all files inside fixtures/" do
    setup do
      Mock.mock_now(H.ntime(2021, 1, 30, 7, 26))
    end

    test "only files older than 25 seconds ago" do
      result = run(~W[ w test/fixtures/* mlt 30_seconds_ago ])

      expected = [
        "test/fixtures/video1.m4v",
        "test/fixtures/video3.mpg",
        "test/fixtures/video4.flv",
        "test/fixtures/video5.avi",
        "test/fixtures/pic1.jpg"
      ]

      assert result == expected
    end
  end
end
