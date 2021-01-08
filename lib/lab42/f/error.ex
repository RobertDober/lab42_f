defmodule Lab42.F.Error do
  @moduledoc false
  defexception [:message]
  @doc false
  def exception(msg), do: %__MODULE__{message: msg}
end
