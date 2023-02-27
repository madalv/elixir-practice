defmodule CrashCounter do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def new_crash() do
    GenServer.cast(__MODULE__, {:new_crash})
  end

  def notify_supervisor() do
    MainSupervisor.deploy_airbag()
  end

  def handle_cast({:new_crash}, state) do
    Logger.debug("New crash detected. Crash cnt #{state + 1} / 2")

    if state + 1 >= 2 do
      notify_supervisor()
      {:noreply, state + 1}
    else
      {:noreply, state + 1}
    end
  end
end
