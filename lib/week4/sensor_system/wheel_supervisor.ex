defmodule WheelSupervisor do
  use Supervisor
  require Logger

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      %{
        id: :wheel1_sensor,
        start: {Sensor, :start_link, ["Wheel 1 Sensor"]}
      },
      %{
        id: :wheel2_sensor,
        start: {Sensor, :start_link, ["Wheel 2 Sensor"]}
      },
      %{
        id: :wheel3_sensor,
        start: {Sensor, :start_link, ["Wheel 3 Sensor"]}
      },
      %{
        id: :wheel4_sensor,
        start: {Sensor, :start_link, ["Wheel 4 Sensor"]}
      },
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_process(atom) do
    Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {id, _, _, _} -> id == atom end)
    |> elem(1)
  end

end
