defmodule Lab42.F.FileInfo do
  use Lab42.F.Types

  @moduledoc false
  defstruct name: "", stat: %File.Stat{}

  @type t :: %__MODULE__{name: binary(), stat: File.Stat.t}
  @type ts :: list(ts)

  @spec dir?(t()) :: boolean()
  def dir?(file_info)
  def dir?(%__MODULE__{stat: %File.Stat{type: :directory}}), do: true
  def dir?(_), do: false

  @spec new(binary()) :: t()
  def new(filename) do
    %__MODULE__{name: filename, stat: File.lstat!(filename)}
  end

  @spec naive_time_stamp(t(), atom()) :: NaiveDateTime.t
  def naive_time_stamp(name_info, time_stamp_type \\ :mtime)
  def naive_time_stamp(%__MODULE__{stat: fstat}, time_stamp_type) do
    apply( &NaiveDateTime.new/6,
      fstat
      |> Map.get(time_stamp_type)
      |> Tuple.to_list
      |> Enum.map(&Tuple.to_list/1)
      |> List.flatten)
  end
end
