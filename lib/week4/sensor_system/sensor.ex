defmodule Sensor do
  use GenServer
  require Logger

  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    Logger.info("#{init_arg} starting...")
    {:ok, init_arg}
  end

  def handle_info({:EXIT, _from, reason}, state) do
    Logger.warn("#{state} detected a failure!")
    {:stop, reason, state}
  end


  def terminate(_reason, _state) do
    CrashCounter.new_crash()
  end

end
