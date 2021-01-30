defmodule Lab42.F.Parser do
  use Lab42.F.Types
  @moduledoc """
  ```elixir
  defstruct wildcard: "*",
    type: nil,  # e.g. "vid", "elixir", ...
    mgt: nil, # date modification date greater than
    mlt: nil, # date modification date less than
    sgt: nil, # size greater than
    slt: nil, # size less than
    rgx: nil, # additional regex filter
    transform: "%p" # see for details in the README or in Lab42.F.Transform
  ```
  """

  defstruct wildcard: "*",
    type: nil,  # e.g. "vid", "elixir", ...
    mgt: nil, # date modification date greater than
    mlt: nil, # date modification date less than
    sgt: nil, # size greater than
    slt: nil, # size less than
    rgx: ~r{.}, # additional regex filter
    transform: "%p" # see for details in the README or in Lab42.F.Transform

  @type t :: %__MODULE__{
    wildcard: binary(),
    transform: binary(),
    type: binary?(),
    mgt: binary?(),
    mlt: binary?(),
    sgt: binary?(),
    slt: binary?(),
    rgx: binary?(),
  }

  @spec parse(binaries()) :: t()
  def parse(argv) do
    _parse(argv, struct!(__MODULE__))
  end

  @spec _check_values!(t()) :: t()
  defp _check_values!(parser) do
    if parser.wildcard == "boom" do
      raise "oh no"
    else
      parser
    end
  end

  @spec _parse(binaries(), t()) :: t()
  defp _parse(argv, result)
  defp _parse([], result) do
    result |> _check_values!()
  end
  defp _parse(["w", wildcard|rest], result) do
    _parse(rest, %{result | wildcard: wildcard})
  end
  defp _parse(["t", type | rest], result) do
    _parse(rest, %{result | type: type})
  end
  defp _parse(["mgt", mgt | rest], result) do
    _parse(rest, %{result | mgt: mgt})
  end
  defp _parse(["mlt", mlt | rest], result) do
    _parse(rest, %{result | mlt: mlt})
  end
  defp _parse(["sgt", sgt | rest], result) do
    _parse(rest, %{result | sgt: sgt})
  end
  defp _parse(["slt", slt | rest], result) do
    _parse(rest, %{result | slt: slt})
  end
  defp _parse(["rgx", rgx | rest], result) do
    _parse(rest, %{result | rgx: rgx})
  end
  defp _parse(rest, result) do
    %{result | transform: Enum.join(rest, " ")} |> _check_values!()
  end
end
