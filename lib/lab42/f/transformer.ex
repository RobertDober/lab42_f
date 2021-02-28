defmodule Lab42.F.Transformer do
  use Lab42.F.Types

  alias Lab42.F.{File, Transformations}

  @moduledoc false

  @doc false
  @spec transform(Lab42.F.Finder.t()) :: binaries()
  def transform(file_list_transform)

  def transform({file_list, transform}) do
    compiled = Transformations.compile(transform)
    transform_file_list(file_list, compiled)
  end

  defp transform_file_list(file_list, compiled, result \\ [])

  defp transform_file_list([], _compiled, result) do
    Enum.reverse(result)
  end

  defp transform_file_list([file | rest], compiled, result) do
    result1 = apply_compiled(compiled, {[], file})
    transform_file_list(rest, compiled, [result1 | result])
  end

  defp apply_compiled(compiled, result_ctxt) 
  defp apply_compiled([], {result, _}) do
    result
    |> Enum.reverse
    |> Enum.join
  end
  defp apply_compiled([cfun|rest], {result, ctxt}) do
    with {result1, ctxt1} <- cfun.(ctxt) do
      apply_compiled(rest, {[result1 | result], ctxt1})
    end
  end
end
