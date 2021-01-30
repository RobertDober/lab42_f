defmodule Lab42.F.Transformer do
  use Lab42.F.Types

  @moduledoc false

  @spec transform(Lab42.F.Finder.t)::binaries()
  def transform(file_list_transform)
  def transform({file_list, transform}) do
    apply_transform(file_list, compile_transform(transform))
  end

  defp apply_transform(file, compiled_transform) do
    compiled_transform
    # |> IO.inspect
    |> Enum.map(&apply_transform_to_chunk(file, &1))
    |> Enum.join
  end

  defp apply_transform_to_chunk(file, chunk)
  defp apply_transform_to_chunk(_file, chunk) when is_binary(chunk), do: chunk
  defp apply_transform_to_chunk(file, {pattern, fun}), do: fun.(file, pattern) 

  @pattern_rgx ~r"""
  (?: 
    (?<!%) (?:
      %% | %p | %P | %b | %BX | %B  # prefix expressions must always follow their suffixed brethens, to allow them to match first
      | %d | %D | %x | %X | %rx\d*
    )
    | [^%]* )
  """x
  @transforms %{
    "b" => &__MODULE__.basename/2,
    "B" => &__MODULE__.basename_wo_last_ext/2,
    "s" => &__MODULE__.verbatim_space/2,
    "%" => &__MODULE__.verbatim_percent/2,
  }
  defp compile_transform(transform) do
    Regex.scan(@pattern_rgx, transform)
    |> List.flatten
    |> Enum.map(&replace_patterns_with_functions/1)
  end

  defp replace_patterns_with_functions(pattern)
  defp replace_patterns_with_functions("%%"), do: "%%"
  defp replace_patterns_with_functions("%" <> pattern) do
    {pattern, Map.get(@transforms, pattern, &_not_yet_implemented/2)}
  end
  defp replace_patterns_with_functions(pattern), do: pattern

  defp _not_yet_implemented(_file, pattern) do
    raise Lab42.F.Error, ~s{the pattern "%#{pattern}" is not yet implemented}
  end

  def basename(file, _pattern) do
    Path.basename(file)
  end

  @last_ext_rgx ~r{ \. [^\.]* \z}x
  def basename_wo_last_ext(file, _pattern) do
    Path.basename(file)
    |> String.replace(@last_ext_rgx, "")
  end

  def verbatim_percent(_file, _pattern) do
    "%"
  end

  def verbatim_space(_file, _pattern) do
    " "
  end
end
