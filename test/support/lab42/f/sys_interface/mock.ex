defmodule Lab42.F.SysInterface.Mock do
  @behaviour Lab42.F.SysInterface.Behavior

  def start_link do
    Agent.start_link(fn -> %{messages: []} end, name: __MODULE__)
  end

  def clear do
    Agent.update(__MODULE__, fn _ -> %{messages: []} end)
  end

  def messages do
     Agent.get(__MODULE__, &(&1.messages))
  end

  def mock_now do
    mock_now NaiveDateTime.utc_now
  end

  def mock_now ntime do
    Agent.update(__MODULE__, &Map.put(&1, :now, ntime)) 
  end

  def mock_random_byte do
    rb =
      Enum.random(1..256)
      |> Integer.to_string(16)
      |> String.downcase()
    Agent.update(__MODULE__, &Map.put(&1, :random_byte, rb)) 
    rb
  end

  @spec expand(binary()) :: binary()
  @impl true
  def expand(file) do
    Path.join("/abspath", file)
  end

  @spec now() :: NaiveDateTime.t
  @impl true
  def now do
    Agent.get(__MODULE__, &Map.get(&1, :now))
  end

  @spec random_byte() :: binary()
  @impl true
  def random_byte do
    Agent.get(__MODULE__, &Map.get(&1, :random_byte))
  end
end
