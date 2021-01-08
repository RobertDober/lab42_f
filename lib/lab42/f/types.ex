defmodule Lab42.F.Types do
  
  defmacro __using__(_opts) do
    quote do
      @type binaries :: list(binary())

      @type maybe(t) :: t | nil
    end
  end
end
