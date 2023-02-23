defmodule Joiner do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(list) do
    GenServer.call(__MODULE__, list)
  end

  def handle_call(list, _from, _state) do
    Logger.debug("Joiner got: " <> inspect(list))
    result = Enum.join(list, " ")
    Logger.info("Result: " <> result)
    {:reply, result, list}
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Joiner #{inspect(state)}")
  end
end
