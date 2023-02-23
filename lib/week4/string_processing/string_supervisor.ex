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

  def process(string) do
    string
    |> Splitter.work()
    |> Swapper.work()
    |> Joiner.work()
  end
end
