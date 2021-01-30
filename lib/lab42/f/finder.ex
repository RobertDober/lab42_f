defmodule Lab42.F.Finder do
  use Lab42.F.Types

  alias Lab42.F.{FileInfo, Parser}

  @moduledoc false

  @spec find(Lab42.F.Parser.t) :: binaries() 
  def find(parsed)
  def find(%{wildcard: wc}=parsed) do
    wc
    |> Path.wildcard
    |> Enum.map(&FileInfo.new/1)
    |> Enum.reject(&FileInfo.dir?/1)
    |> Enum.filter(&filter(&1, parsed))
    |> Enum.sort_by(&(&1.stat.mtime))
    |> Enum.map(&{&1.name, parsed.transform})
  end

  defp filter(file_info, parsed) do
    filter_times(file_info, parsed) &&
      filter_size(file_info, parsed) &&
        filter_rgx(file_info, parsed
  end

  defp filter_rgx(file_info, %{rgx: rgx}) do
    Regex.match?(rgx, file_info.name)
  end

  defp filter_size(_file_info, _parsed) do
    true
  end

  defp filter_times(file_info, parsed)
  defp filter_times(file_info, %Parser{mgt: nil, mlt: nil}) do
    true
  end
  defp filter_times(file_info, %Parser{mgt: mgt, mlt: nil}) do
  end
  defp filter_times(file_info, %Parser{mgt: nil, mlt: mlt}) do
  end
end
