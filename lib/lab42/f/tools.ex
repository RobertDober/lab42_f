defmodule Lab42.F.Tools do
  use Lab42.F.Types
  @moduledoc false

  @typep tuple_f :: ({any(), any()} -> any())
  @spec zip_with(list(), list(), tuple_f()) :: list()
  def zip_with(e1, e2, f \\ &(&1)) do
    _zip_with(e1, e2, f, []) 
  end

  @spec _zip_with(list(), list(), tuple_f(), list()) :: list()
  defp _zip_with([h1|t1], [h2|t2], f, result) do
    _zip_with(t1, t2, f, [f.({h1, h2})|result])
  end
  defp _zip_with([], [h2|t2], f, result) do
    _zip_with([], t2, f, [f.({nil, h2})|result])
  end
  defp _zip_with([h1|t1], [], f, result) do
    _zip_with(t1, [], f, [f.({h1, nil})|result])
  end
  defp _zip_with([], [], _, result) do
    Enum.reverse(result)
  end
end
