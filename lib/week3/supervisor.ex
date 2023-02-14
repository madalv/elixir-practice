defmodule Sup do
  def start do
    spawn(__MODULE__, :loop, [[]])
  end

  def schedule(pid, task) do
    send(pid, {:task, task})
  end

  def create_worker() do
    worker = Worker.start()
    Process.monitor(worker)
    worker
  end

  def schedule_worker(task, worker) do
    send(worker, {:task, task})
  end

  def loop(list) do
    receive do
      {:task, task} ->
        worker = create_worker()
        schedule_worker(task, worker)
        loop(list)

      {:DOWN, _, :process, _, reason} ->
        case reason do
          :normal -> IO.puts("Task successful: Miau")
          _ ->
            task = Atom.to_string(reason)
            IO.puts("Task failed: #{task}")
            worker = create_worker()
            schedule_worker(task, worker)
            loop(list)
        end

      end
  end
end