defmodule Lab42.F do
  use Lab42.F.Types

  usage_info = """

  f [filter_flags] [transformation]

  filter_flags:

      w <wildecard>  defaults to *
      t <prefefined type>
      agt|alt|mgt|mlt <date time>
          <date time> is either an absolute or relative value, see moduledoc of `Lab42.F.Time`

      sgt|slt <file size>
      x <rgx>


  a string in which %&lt;exp> will be replaced as follows and all spaces will
  be ignored  (like in ~r{...}x)

  transformation:

      %p full relative path
      %px full relative path w/o last extension
      %pX full relative path w/o any extension
      %P full expanded (absolute) path
      %b file's base name with extension
      %B file's base name w/o last extension (x.y.z → x.y)
      %BX file's base name w/o all extensions (x.y.z → x)
      %d file's relative dir name
      %D file's expanded dir name
      %x file's last extension (x.y.z → z)
      %X file's extensions (x.y.z → y.z)

      everything else is rendered verbatim

      <exp> is a random string:

      %r<random format>  a random string according to <random format> as follows
      x<n>  n hex digits, e.g. %rx10 → a0df128872


  <exp> constant:
  %s space (\u0020)
  """


  @moduledoc """
  #{usage_info}
  """

  @spec main(binaries()) :: no_return() | :ok
  def main(argv)
  def main([]) do
    _usage()
  end
  def main(["-h"|_]) do
    _usage()
  end
  def main(["--help"|_]) do
    _usage()
  end
  def main(["-v"|_]) do
    _version()
  end
  def main(["--version"|_]) do
    _version()
  end
  def main(argv) do
    argv
    |> run()
    |> Enum.each( &IO.puts/1 )
  end

  @doc false
  @spec run(binaries()) :: binaries()
  def run(argv) do
    parsed = argv
    |> Lab42.F.Parser.parse
    files = parsed
    |> Lab42.F.Finder.find
    Lab42.F.Transformer.transform({files, parsed.transform})
  end
  @usage usage_info
  @spec _usage() :: no_return() 
  defp _usage do
    IO.puts(:stderr, @usage)
    exit(:normal)
  end

  @spec _version() :: no_return()
  defp _version do
    with {:ok, version} = :application.get_key(:lab42_f, :vsn),
         do: IO.puts(:stderr, to_string(version))
           exit(:normal)
    end
end
