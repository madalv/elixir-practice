defmodule Semaphore do
  def create_semaphore(count \\ 1) do
    spawn(Semaphore, :semaphore, [count])
  end

  def release(semaphore) do
    send(semaphore, :release)
  end

  def acquire(semaphore) do
    send(semaphore, {:acquire, self()})

    receive do
      :granted ->
        :ok
    end
  end

  def semaphore(0) do
    receive do
      :release ->
        semaphore(1)
    end
  end

  def semaphore(n) do
    receive do
      {:acquire, from} ->
        send(from, :granted)
        semaphore(n - 1)

      :release ->
        semaphore(n + 1)
    end
  end
end
