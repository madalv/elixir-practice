defmodule Swapper do
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
    Logger.debug("Swapper got: " <> inspect(list))

    if :rand.uniform(2) == 1 do
      exit(:random_failure)
    else
      modified =
        list
        |> Enum.map(fn word ->
          word
          |> String.downcase()
          |> String.split("", trim: true)
          |> Enum.map(fn c ->
            case c do
              "m" -> "n"
              "n" -> "m"
              c -> c
            end
          end)
          |> Enum.join("")
        end)

      {:reply, modified, list}
    end
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Swapper #{inspect(state)}")
  end
end
