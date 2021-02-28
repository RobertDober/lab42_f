defmodule Lab42.F.File do
  use Lab42.F.Types

  @moduledoc false
  defstruct name: "",
            captures: [],
            count: 0,
            ctxt: nil,
            lnb: 0,
            mtime: NaiveDateTime.utc_now()

  @type t :: %__MODULE__{name: binary(), captures: binaries(), ctxt: any(), lnb: non_neg_integer(), mtime: NaiveDateTime.t}

  def new(name, mtime, captures \\ [], count \\ 0) do
    %__MODULE__{name: name, captures: captures, count: count, mtime: mtime}
  end

  def next_line(%__MODULE__{lnb: lnb} = line) do
    %{line | lnb: lnb + 1}
  end
end
