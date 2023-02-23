defmodule Splitter do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(string) do
    GenServer.call(__MODULE__, string)
  end

  def handle_call(string, _from, _state) do
    split = String.split(string, " ", trim: true)
    {:reply, split, string}
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Splitter #{inspect(state)}")
  end
end
