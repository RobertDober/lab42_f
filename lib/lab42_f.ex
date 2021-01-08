defmodule Lab42F do
  @moduledoc """
  Documentation for `Lab42F`.
  """
  def main(argv) do
    usage()
  end

  @usage """
  f [filter_flags] [transformation]

  filter_flags:
    w <wildecard>  defaults to *
    t <prefefined type>
    agt|alt|mgt|mlt <date time>
    sgt|slt <file size>
    f <rgx>

  transformation:
    a string in which %<exp> will be replaced as follows and all spaces will
    be ignored  (like in ~r{...}x)
    
    for each processed file (use %%<exp> for a literal %<exp>)

    <exp> depends on file:

      %p full relative path
      %P full expanded (absolute) path
      %b file's base name with extension
      %B file's base name w/o last extension (x.y.z → x.y)
      %BX file's base name w/o all extensions (x.y.z → x)
      %d file's relative dir name
      %D file's expanded dir name
      %x file's last extension (x.y.z → z)
      %X file's extensions (x.y.z → y.z)

    <exp> is a random string:

      %r<random format>  a random string according to <random format> as follows
         x<n>  n hex digits, e.g. %rx10 → 
     

    <exp> constant:
      %s space (\u0020)
  """
  defp _usage do
    IO.puts(:stderr, @usage)
    exit(1)
  end
end
