defmodule Monitor do
  use GenServer
  require Logger

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def monitor(mon_pid, pid) do
    GenServer.cast(mon_pid, {:monitor, pid})
  end

  def handle_cast({:monitor, pid}, state) do
    Process.monitor(pid)
    {:noreply, state}
  end

  # WHY CAN'T I FUCKING PRINT FROM_PROCES??????
  def handle_info({:DOWN, _, :process, from_process, reason}, state) do
    Logger.info("Monitored process down. Reason: #{Atom.to_string(reason)}}")
    {:noreply, state}
  end
end
