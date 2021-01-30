defmodule Test.Support.TimeHelper do

  def ntime(y, m, d, h \\ 0, mi \\ 0, s \\ 0, ms \\ {0, 0}) do
    NaiveDateTime.new!(y, m, d, h, mi, s, ms)
  end
end
