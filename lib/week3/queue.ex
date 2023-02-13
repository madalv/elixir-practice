defmodule Queue do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def push(queue_pid, item) do
    GenServer.cast(queue_pid, {:push, item})
  end

  def pop(queue_pid) do
    GenServer.call(queue_pid, :pop)
  end

  def list(queue_pid) do
    GenServer.call(queue_pid, :list)
  end

  def init(queue) do
    {:ok, queue}
  end

  def handle_call(:pop, _from, []) do
    # :reply, reply, new_state
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, queue) do
    # :reply, reply, new_state
    {:reply, List.last(queue), List.delete_at(queue, -1)}
  end

  # call = sync, cast = async
  def handle_call(:list, _from, queue) do
    # :reply, reply, new_state
    {:reply, queue, queue}
  end

  def handle_cast({:push, item}, queue) do
    {:noreply, [item | queue]}
  end
end
