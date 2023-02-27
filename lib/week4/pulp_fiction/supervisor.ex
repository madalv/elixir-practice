defmodule PulpFiction.Supervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      JulesWinnfield,
      WhiteGuy
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
