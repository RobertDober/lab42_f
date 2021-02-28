defmodule Lab42.F.SysInterface.Behavior do
  
  @callback expand(binary()) :: binary()
  @callback now() :: NaiveDateTime.t
end
