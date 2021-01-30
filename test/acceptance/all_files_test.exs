defmodule Test.Acceptance.AllFilesTest do
  use ExUnit.Case

  alias Lab42.F.SysInterface.Mock
  alias Test.Support.TimeHelper, as: H

  import Lab42.F, only: [run: 1]

  @all_files ~W[
    video1.m4v video3.mpg video4.flv video5.avi pic1.jpg pic3.png doc1.txt doc2.doc doc3.pdf doc4.md doc5.csv video2.mp4 pic2.JPEG
  ]

  describe "all files inside fixtures/" do
    setup do
      Mock.mock_now(H.ntime(2021, 1, 30, 21, 39, 16))
    end

    test "no filter whatsoever, no transformation" do
      result = run(~W[ w test/fixtures/* ])
      expected = @all_files
        |> Enum.map(&("test/fixtures/#{&1}"))
      assert result == expected
    end
    test "still no filter, but only base name" do
      result = run(~W[ w test/fixtures/* %b ])
      expected = @all_files
      assert result == expected
    end
  end

  describe "files newer than pic1.jpg" do
    test "all of them without extension" do
      result = run(~W[ w test/fixtures/* mlt test/fixtures/pic1.jpg echo%s'%B' ])
      expected = [ "echo 'pic1'", "echo 'pic3'", "echo 'doc1'", "echo 'doc2'", "echo 'doc3'", "echo 'doc4'", "echo 'doc5'", "echo 'video2'", "echo 'pic2'" ]
      assert result == expected
    end
  end
end
