defmodule Week4.Worker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(pid, string) do
    GenServer.call(pid, string)
  end

  def die(pid) do
    Process.exit(pid, :kill)
  end

  def handle_call(string, _from, _state) do
    {:reply, string, string}
  end

  def terminate(_reason, state) do
    Logger.debug("Worker #{inspect(self())} down #{inspect(state)}")
  end
end
