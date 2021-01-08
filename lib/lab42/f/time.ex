defmodule Lab42.F.Time do
  alias Lab42.F.Error

  @spec make_time(binary()) :: DateTime.t
  def make_time(from_string)
  def make_time(from_string) do
    case DateTime.from_iso8601(from_string) do
      {:ok, time, _offset} -> time
      _                    -> raise Error, "illegal time spec #{from_string}"
    end
  end
end
