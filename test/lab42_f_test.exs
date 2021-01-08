defmodule Lab42FTest do
  use ExUnit.Case
  doctest Lab42F

  test "greets the world" do
    assert Lab42F.hello() == :world
  end
end
