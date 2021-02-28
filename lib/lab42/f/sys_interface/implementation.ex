defmodule Lab42.F.SysInterface.Implementation do
  @behaviour Lab42.F.SysInterface.Behavior

  @spec expand(binary()) :: binary()
  @impl true
  def expand(file) do
    Path.absname(file)
  end

  @spec now() :: NaiveDateTime.t()
  @impl true
  def now do
    NaiveDateTime.utc_now()
  end

  @spec random_byte() :: binary()
  @impl true
  def random_byte do
    Enum.random(1..256)
    |> Integer.to_string(16)
    |> String.downcase()
  end
end
