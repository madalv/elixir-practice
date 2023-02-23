defmodule StringSupervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      Splitter,
      Swapper,
      Joiner
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def start_processing(string) do
    Splitter.echo(Splitter, string)
  end
end

defmodule Splitter do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def echo(pid, string) do
    GenServer.cast(pid, {:echo, string})
  end

  def handle_cast({:echo, string}, _state) do
    Swapper.echo(Swapper, String.split(string, " ", trim: true))
    {:noreply, string}
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Splitter #{inspect(state)}")
  end
end

defmodule Swapper do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def echo(pid, list) do
    Logger.debug("Swapper got: " <> inspect(list))
    GenServer.cast(pid, {:echo, list})
  end

  def handle_cast({:echo, list}, _state) do
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

      Joiner.echo(Joiner, modified)

      {:noreply, modified}
    end
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Swapper #{inspect(state)}")
  end
end

defmodule Joiner do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def echo(pid, list) do
    GenServer.cast(pid, {:echo, list})
  end

  def handle_cast({:echo, list}, _state) do
    Logger.debug("Joiner got: " <> inspect(list))
    Logger.info("Result: " <> Enum.join(list, " "))
    {:noreply, list}
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Joiner #{inspect(state)}")
  end
end
