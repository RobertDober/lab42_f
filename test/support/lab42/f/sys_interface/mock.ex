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

  @spec now() :: NaiveDateTime.t
  @impl true
  def now do
    Agent.get(__MODULE__, &Map.get(&1, :now))
  end

end
