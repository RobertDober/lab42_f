defmodule Lab42.F.Types do
  
  defmacro __using__(_opts) do
    quote do
      @type binaries :: list(binary())

      @type maybe(t) :: t | nil
      @type binary? :: maybe(binary())

      @type time_t :: :calendar.datetime()
    end
  end
end
