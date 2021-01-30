defmodule Lab42.F.Finder do
  use Lab42.F.Types

  alias Lab42.F.FileInfo

  @moduledoc false

  @spec find(Lab42.F.Parser.t) :: binaries() 
  def find(parsed)
  def find(%{wildcard: wc}=parsed) do
    wc
    |> Path.wildcard
    |> Enum.map(&FileInfo.new/1)
    |> Enum.reject(&FileInfo.dir?/1)
    |> Enum.sort_by(&(&1.stat.mtime))
    |> Enum.map(&{&1.name, parsed.transform})
  end

  @spec _files_only(binary())::FileInfo.ts
  defp _files_only(wc) do
  end
end
