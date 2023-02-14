defmodule Monitor do
  use GenServer
  require Logger

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def monitor(mon_pid, pid) do
    GenServer.cast(mon_pid, {:monitor, pid})
  end

  def handle_cast({:monitor, pid}, state) do
    Process.monitor(pid)
    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, _, reason}, state) do
    Logger.info("Monitored process down. Reason: #{Atom.to_string(reason)}")
    {:noreply, state}
  end
end
