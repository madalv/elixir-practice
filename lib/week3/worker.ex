defmodule Worker do
  def start() do
    spawn(__MODULE__, :loop, [])
  end

  def loop() do
    receive do
      {:task, task} ->
        if :rand.uniform(2) == 1 do
          exit(:normal)
        else
          exit(String.to_atom(task))
        end
    end
  end
end
