defmodule Lab42.F.SysInterface.Behavior do
  
  @callback expand(binary()) :: binary()
  @callback now() :: NaiveDateTime.t
  @callback random_byte() :: binary()
end
