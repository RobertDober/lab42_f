defmodule Lab42.F.SysInterface.Implementation do
  
  @behaviour Lab42.F.SysInterface.Behavior

  @spec expand(binary()) :: binary()
  @impl true
  def expand(file) do
    Path.absname(file)
  end

  @spec now() :: NaiveDateTime.t 
  @impl true
  def now do
    NaiveDateTime.utc_now
  end
end
