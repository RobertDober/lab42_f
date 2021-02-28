defmodule Lab42.F.Transformer do
  use Lab42.F.Types

  @moduledoc false

  @sys_interface Application.fetch_env!(:lab42_f, :sys_interface)

  @doc false
  @spec transform(Lab42.F.Finder.t()) :: binaries()
  def transform(file_list_transform)

  def transform({file_list, transform}) do
    apply_transform(file_list, compile_transform(transform))
  end

  defp apply_transform(file_list, compiled_transform) do
    file_list
    |> Enum.map(&apply_transform_to_file(&1, compiled_transform))
  end

  defp apply_transform_to_file(file, compiled_transform) do
    compiled_transform
    |> Enum.map(&apply_transform_to_chunk(file, &1))
    |> Enum.join()
  end

  defp apply_transform_to_chunk(file, chunk)
  defp apply_transform_to_chunk(_file, chunk) when is_binary(chunk), do: chunk
  defp apply_transform_to_chunk(file, {pattern, fun}), do: fun.(file, pattern)

  @pattern_rgx ~r"""
  (?: 
    (?<!%) (?:
      # prefix expressions must always follow their suffixed brethens, to allow them to match first
      %% | %px | %pX | %p | %Px | %PX | %P | %bx | %bX | %b 
         | %d | %D | %x | %X | %rx\d* | %s
         | %e
    )
    | [^%]* )
  """x
  @transforms %{
    "b"  => &__MODULE__.basename/2,
    "bx" => &__MODULE__.basename_wo_ext/2,
    "bX" => &__MODULE__.basename_wo_any_ext/2,
    "d"  => &__MODULE__.rel_dirname/2,
    "D"  => &__MODULE__.abs_dirname/2,
    "e"  => &__MODULE__.empty/2,
    "p"  => &__MODULE__.full_relative_path/2,
    "px" => &__MODULE__.full_relative_path_wo_ext/2,
    "pX" => &__MODULE__.full_relative_path_wo_any_ext/2,
    "P"  => &__MODULE__.full_absolute_path/2,
    "Px" => &__MODULE__.full_absolute_path_wo_ext/2,
    "PX" => &__MODULE__.full_absolute_path_woany_ext/2,
    "s"  => &__MODULE__.verbatim_space/2,
    "x"  => &__MODULE__.last_extension/2,
    "X"  => &__MODULE__.all_extensions/2,
    "%"  => &__MODULE__.verbatim_percent/2
  }

  @last_ext_rgx ~r{ \. [^\.]* \z}x
  @last_ext_pfx ~r{ .* \. }x

  defp compile_transform(transform) do
    Regex.scan(@pattern_rgx, transform)
    |> List.flatten()
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

  def abs_dirname(file, _pattern) do
    file
    |> @sys_interface.expand
    |> Path.dirname
  end

  @extension_suffix ~r{ \A [^.]+ }x 
  def all_extensions(file, _pattenr) do
    file
    |> String.replace(@extension_suffix, "")
  end

  def basename(file, _pattern) do
    Path.basename(file)
  end

  def basename_wo_ext(file, _pattern) do
    file
    |> Path.basename
    |> wo_last_extension()
  end

  def basename_wo_any_ext(file, _pattern) do
    file
    |> Path.basename
    |> wo_any_extension()
  end

  def empty(_file, _pattern) do
    ""
  end

  def full_absolute_path(file, _pattern) do
    @sys_interface.expand(file)
  end

  def full_absolute_path_woany_ext(file, _pattern) do
    file
    |> full_absolute_path(nil)
    |> wo_any_extension()
  end

  def full_absolute_path_wo_ext(file, _pattern) do
    file
    |> full_absolute_path(nil)
    |> wo_last_extension()
  end

  def full_relative_path(file, _pattern) do
    file
  end

  def full_relative_path_wo_any_ext(file, _pattern) do
    file
    |> wo_any_extension()
  end

  def full_relative_path_wo_ext(file, _pattern) do
    file
    |> wo_last_extension()
  end

  def last_extension(file, _pattern) do
    case String.split(file, ".") do
      [_hd] -> ""
       x  -> "." <> (Enum.reverse(x) |> hd())
    end
  end

  def rel_dirname(file, _pattern) do
    file
    |> Path.dirname
  end

  def verbatim_percent(_file, _pattern) do
    "%"
  end

  def verbatim_space(_file, _pattern) do
    " "
  end

  defp wo_last_extension(file) do
    file
    |> String.replace(@last_ext_rgx, "")
  end

  defp wo_any_extension(file) do
    ( String.split(file, ".")
    |> List.first ) || ""
  end
end
