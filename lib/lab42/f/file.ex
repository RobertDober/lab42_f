defmodule Lab42.F.File do
  @moduledoc false
  defstruct name: "",
            captures: [],
            count: 0,
            lnb: 0,
            mtime: NaiveDateTime.utc_now()

  def new(name, mtime, captures \\ [], count \\ 0) do
    %__MODULE__{name: name, captures: captures, count: count, mtime: mtime}
  end

  def next_line(%__MODULE__{lnb: lnb} = line) do
    %{line | lnb: lnb + 1}
  end
end
