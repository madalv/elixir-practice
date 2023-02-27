defmodule MainSupervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      CrashCounter,
      WheelSupervisor,
      %{
        id: :cabin_sensor,
        start: {Sensor, :start_link, ["Cabin Sensor"]}
      },
      %{
        id: :motor_sensor,
        start: {Sensor, :start_link, ["Motor Sensor"]}
      },
      %{
        id: :chassis_sensor,
        start: {Sensor, :start_link, ["Chassis Sensor"]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def deploy_airbag() do
    Logger.warn("DEPLOYING AIRBAGS.")
  end

  def get_process(atom) do
    Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {id, _, _, _} -> id == atom end)
    |> elem(1)
  end

end
