defmodule Test.Support.Trans do
  @moduledoc false

  alias Lab42.F.File

  @sys_interface Application.fetch_env!(:lab42_f, :sys_interface)
  def trans({files, transform}) do
    file_structs = _mk_file_structs(files)
    Lab42.F.Transformer.transform({file_structs, transform})
  end

  defp _mk_file_structs(files) do
    with {result, _} <-
           files
           |> Enum.map_reduce(0, fn ele, count ->
             {File.new(ele, @sys_interface.now, [], count), count + 1}
           end),
         do: result
  end
end
