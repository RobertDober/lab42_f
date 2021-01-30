defmodule Lab42.F.Time do
  use Lab42.F.Types
  alias Lab42.F.Error
  import Lab42.F.Tools, only: [zip_with: 3]

  @moduledoc """
  a time value can specified, either by relative values, like

  `1_day_ago`

  or by partial absolute values, still relative to the current date

  `30` (30th of current month)
  `12-01` (<current-year>-12-01T00:00:00Z)
  `3 14`  (<current-year>-<current-month>-03T14:00:00Z)

  or by complete timestamps (well hours, minutes and seconds still default to 0, and the century to 21)

  `14-03-01` (2014-03-01T00:00:00Z)
  `14-3-1 12` (2014-03-01T12:00:00Z)
  """

  # defstruct year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, microsecond: {0, 0}, calendar: Calendar.ISO
  # @typep time_rep_t :: list(non_neg_integer())
  # @typep value_t :: maybe(non_neg_integer())

  # @type t :: %__MODULE__{
  #   year: value_t(),
  #   month: value_t(),
  #   day: value_t(),
  #   hour: value_t(),
  #   minute: value_t(),
  #   second: value_t(),
  #   microsecond: {non_neg_integer(), non_neg_integer},
  #   calendar: module()
  # }

  @sys_interface Application.fetch_env!(:lab42_f, :sys_interface)

  @secs_per_unit %{
    "d" => 86400,
    "day" => 86400,
    "days" => 86400,
    "h" => 3600,
    "hours" => 3600,
    "hour" => 3600,
    "m" => 60,
    "minutes" => 60,
    "minute" => 60,
    "s" => 1,
    "seconds" => 1,
    "second" => 1,
  }

  @long_rel_spec ~r{\A (\d+) _ ([[:alpha:]]+) _ ago \z}x
  @short_rel_spec ~r{\A -(\d+)  ([dhms]) s? \z}x

  # @spec new(Keyword.t) :: t()
  # def new(opts \\ []) do
  #   now = now()
  #   struct(__MODULE__)
  #   |> Map.from_struct
  #   |> Map.keys
  #   |> Enum.reduce( struct(__MODULE__), fn field, result -> 
  #     %{result|field => Keyword.get(opts, field, Map.get(now, field))}
  #   end)
  # end

  @spec make_time(binary()) :: NaiveDateTime.t
  def make_time(from_string)
  def make_time(from_string) do
    lm = Regex.run(@long_rel_spec, from_string)
    sm = Regex.run(@short_rel_spec, from_string)
    case {lm, sm} do
      {nil, nil} -> _make_absolute_time(from_string)
      _ -> _make_relative_time(lm || sm)
    end
  end

  @date_time_sep ~r{ [\sT] }x
  # TODO: Refactor
  @spec _compile_iso8601(binary()) :: time_rep_t()
  defp _compile_iso8601(partial_time) do
    case String.split(partial_time, @date_time_sep) do
      [date, time] -> 
        date1 = _complete_date(date)
        time1 = _complete_time(time)
        date1 ++ time1
      [date_or_time] ->
        {date1, time1} = _determine_date_or_time(date_or_time)
        date2 = _complete_date(date1)
        time2 = _complete_time(time1)
        date2 ++ time2
    end
  end

  @date_sep ~r{ [-/] }x
  @spec _complete_date(binary?()) :: time_rep_t()
  defp _complete_date(date)
  defp _complete_date(nil) do
    _current_date()
  end
  defp _complete_date(date) do
    date
    |> String.split(@date_sep)
    |> Enum.map(&_atoi/1)
    |> _lpad_with(nil, 3)
    |> zip_with(_current_date(), fn {given, default} -> given || default end)
  end

  @time_sep ~r{ : }x
  @spec _complete_time(binary?()) :: time_rep_t()
  defp _complete_time(time)
  defp _complete_time(nil) do
    [0, 0, 0]
  end
  defp _complete_time(time) do
    time
    |> String.split(@time_sep)
    |> Enum.map(&_atoi/1)
    |> zip_with(Stream.iterate(0, &(&1))|>Enum.take(3), fn {given, default} -> given || default end)
    |> zip_with(repeat(0, 3), fn {given, default} -> given || default end)
  end

  @spec _current_date() :: list()
  defp _current_date do
    now = now()
    [now.year, now.month, now.day]
  end

  @time_rgx ~r{ : }x
  @spec _determine_date_or_time(binary()) :: {nil, binary()} | {binary(), nil}
  defp _determine_date_or_time(date_or_time) do
    if Regex.match?(@time_rgx, date_or_time) do
      {nil, date_or_time}
    else
      {date_or_time, nil}
    end
  end

  @spec _make_absolute_time(binary()) :: NaiveDateTime.t
  defp _make_absolute_time(from_string) do
    time_spec = _compile_iso8601(from_string)
    case apply(&NaiveDateTime.new/6, time_spec) do
      {:ok, ndt} -> ndt
      _          -> raise Error, "illegal absolute time #{from_string}"
    end
  end

  @spec _make_relative_time(binaries()) :: NaiveDateTime.t
  defp _make_relative_time(from_match)
  defp _make_relative_time([_, digits, units]) do
    conversion = Map.get(@secs_per_unit, units)
    if conversion do
      _make_relative_seconds(conversion, digits)
    else
      raise Error, "illegal relative time unit: #{units}"
    end
  end

  @spec _make_relative_seconds(number(), binary()) :: NaiveDateTime.t
  defp _make_relative_seconds(conversion, digits) do
    NaiveDateTime.add(now(), -_atoi(digits) * conversion)
  end

  @spec _atoi(binary()) :: integer()
  defp _atoi(str) do
    case Integer.parse(str) do
      {n, ""} -> n
      _ -> raise Error, "illegal number #{str}"
    end
  end

  @spec now() :: NaiveDateTime.t
  def now do
    @sys_interface.now
  end

  defp _lpad_with(list, value, size) do
    Enum.reverse(list) ++ repeat(value, size)
    |> Enum.take(size)
    |> Enum.reverse
  end

  def repeat(element, times) do
    Stream.cycle([element]) |> Enum.take(times)
  end
end
