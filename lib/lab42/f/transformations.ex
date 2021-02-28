defmodule Lab42.F.Transformations do
  @moduledoc false

  @sys_interface Application.fetch_env!(:lab42_f, :sys_interface)

  @pattern_rgx ~r"""
      # prefix expressions must always follow their suffixed brethens, to allow them to match first
      %% | %px | %pX | %p | %Px | %PX | %P | %bx | %bX | %b 
      | %d | %D | %x | %X | %rx | %s
        | %e | [^%]+
  """x
  @transforms %{
    "b" => &__MODULE__.basename/1,
    "bx" => &__MODULE__.basename_wo_ext/1,
    "bX" => &__MODULE__.basename_wo_any_ext/1,
    "d" => &__MODULE__.rel_dirname/1,
    "D" => &__MODULE__.abs_dirname/1,
    "e" => "",
    "p" => &__MODULE__.full_relative_path/1,
    "px" => &__MODULE__.full_relative_path_wo_ext/1,
    "pX" => &__MODULE__.full_relative_path_wo_any_ext/1,
    "P" => &__MODULE__.full_absolute_path/1,
    "Px" => &__MODULE__.full_absolute_path_wo_ext/1,
    "PX" => &__MODULE__.full_absolute_path_woany_ext/1,
    "s" => " ",
    "x" => &__MODULE__.last_extension/1,
    "X" => &__MODULE__.all_extensions/1,
    "%" => "%"
  }

  # @digits_rgx ~r/\A \d+ /x
  def compile(transform, result \\ [])

  def compile("", result) do
    Enum.reverse(result)
    # |> IO.inspect
  end

  def compile("%rx" <> rest, result) do
    {digits, rest2} =
      case Integer.parse(rest) do
        :error -> {4, rest}
        parsed -> parsed
      end

    random_gen = make_random_x_gen(digits)
    compile(rest2, [random_gen | result])
  end

  def compile(<<char>> <> rest, result) do
    compile(rest, [make_identity(char) | result])
  end

  # defp fetch(rgx, str) do
  #   case Regex.run(str) do
  #     nil -> {nil, str}
  #     [match | _] -> {match, String.slice(str, String.length(match), String.length(str))}
  #   end
  # end

  defp make_identity(value) do
    fn ctxt ->
      # IO.inspect(value, label: :identity)
      {[value], ctxt}
    end
  end

  defp make_random_x_gen(len) do
    fn ctxt ->
      {
        @sys_interface.random_byte
        |> Stream.iterate(fn _ -> @sys_interface.random_byte end)
        |> Enum.take(len)
        |> Enum.join,
        ctxt
      }
    end
  end

  def abs_dirname(file) do
    file.name
    |> @sys_interface.expand
    |> Path.dirname()
    |> with_file(file)
  end

  @extension_suffix ~r{ \A [^.]+ }x
  def all_extensions(file) do
    file.name
    |> String.replace(@extension_suffix, "")
    |> with_file(file)
  end

  def basename(file) do
    Path.basename(file.name)
    |> with_file(file)
  end

  def basename_wo_ext(file) do
    file.name
    |> Path.basename()
    |> wo_last_extension()
    |> with_file(file)
  end

  def basename_wo_any_ext(file) do
    file.name
    |> Path.basename()
    |> wo_any_extension()
    |> with_file(file)
  end

  def full_absolute_path(file) do
    _full_absolute_path(file.name)
    |> with_file(file)
  end

  def full_absolute_path_woany_ext(file) do
    file.name
    |> _full_absolute_path()
    |> wo_any_extension()
    |> with_file(file)
  end

  def full_absolute_path_wo_ext(file) do
    file.name
    |> _full_absolute_path()
    |> wo_last_extension()
    |> with_file(file)
  end

  def full_relative_path(file) do
    file.name
    |> with_file(file)
  end

  def full_relative_path_wo_any_ext(file) do
    file.name
    |> wo_any_extension()
    |> with_file(file)
  end

  def full_relative_path_wo_ext(file) do
    file.name
    |> wo_last_extension()
    |> with_file(file)
  end

  def last_extension(file) do
    case String.split(file.name, ".") do
      [_hd] -> with_file("", file)
      x -> with_file("." <> (Enum.reverse(x) |> hd()), file)
    end
  end

  def rel_dirname(file) do
    file.name
    |> Path.dirname()
  end

  defp replace_patterns_with_functions(pattern)

  defp replace_patterns_with_functions("%" <> pattern) do
    case Map.get(@transforms, pattern) do
      nil -> _not_yet_implemented(pattern)
      string when is_binary(string) -> literal(string)
      replacer -> replacer
    end
  end

  defp replace_patterns_with_functions(pattern), do: literal(pattern)

  defp _not_yet_implemented(pattern) do
    raise Lab42.F.Error, ~s{the pattern "%#{pattern}" is not yet implemented}
  end

  defp literal(value) do
    fn fi -> {value, fi} end
  end

  defp _full_absolute_path(file_name) do
    @sys_interface.expand(file_name)
  end

  defp with_file(value, file), do: {value, file}

  @last_ext_rgx ~r{ \. [^.]* \z }x
  defp wo_last_extension(file) do
    file
    |> String.replace(@last_ext_rgx, "")
  end

  defp wo_any_extension(file) do
    String.split(file, ".")
    |> List.first() || ""
  end
end
