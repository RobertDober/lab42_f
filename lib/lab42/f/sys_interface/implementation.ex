defmodule Lab42.F.SysInterface.Implementation do
  
  @behaviour Lab42.F.SysInterface.Behavior

  @spec now() :: NaiveDateTime.t 
  def now do
    NaiveDateTime.utc_now
  end
end
