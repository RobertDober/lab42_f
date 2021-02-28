defmodule Lab42.F.Finder do
  use Lab42.F.Types

  alias Lab42.F.{File,FileInfo, Parser, Time}

  @moduledoc false

  @spec find(Lab42.F.Parser.t) :: binaries() 
  def find(parsed)
  def find(%{wildcard: wc}=parsed) do
    filtered = wc
    |> Path.wildcard
    |> Enum.map(&FileInfo.new/1)
    |> Enum.reject(&FileInfo.dir?/1)
    |> Enum.filter(&filter(&1, parsed))
  filtered
    |> filter_rgx(parsed.rgx, 0)
    |> Enum.sort_by(&(&1.mtime))
    |> Enum.map(&(&1.name))
  end

  defp filter(file_info, parsed) do
    filter_times(file_info, parsed) &&
      filter_size(file_info, parsed)
  end

  defp filter_rgx(file_infos, rgx, count, result \\ [])
  defp filter_rgx([], _rgx, _ount, result) do
    Enum.reverse(result)
  end
  defp filter_rgx([file_info|rest], rgx, count, result) do
    case Regex.run(rgx, file_info.name) do
      nil -> filter_rgx(rest, rgx, count, result)
      matches -> filter_rgx(rest, rgx, count + 1, [File.new(file_info.name, file_info.stat.mtime, matches, count) | result])
    end
  end

  defp filter_size(_file_info, _parsed) do
    true
  end

  defp filter_times(file_info, parsed)
  defp filter_times(_file_info, %Parser{mgt: nil, mlt: nil}) do
    true
  end
  defp filter_times(file_info, %Parser{mgt: mgt, mlt: nil}) do
    this_mtime = Time.naive_date_time_from_file_stat(file_info.stat)
    this_mtime >= mgt
  end

  defp filter_times(file_info, %Parser{mgt: nil, mlt: mlt}) do
    this_mtime = Time.naive_date_time_from_file_stat(file_info.stat)
    # IO.inspect {file_info.name, this_mtime, mlt}
    this_mtime <= mlt
  end
end
