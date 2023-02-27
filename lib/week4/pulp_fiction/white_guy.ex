defmodule WhiteGuy do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def speak(line) do
    GenServer.cast(__MODULE__, {:speak, line})
  end

  def handle_cast({:speak, line}, state) do
    JulesWinnfield.speak(line)
    {:noreply, state}
  end

  def kill() do
    GenServer.cast(__MODULE__, :die)
  end

  def handle_cast(:die, state) do
    {:stop, :gunshot, state}
  end
end
