defmodule Semaphore do
  def create_semaphore(count \\ 1) do
    spawn(Semaphore, :semaphore, [count, count])
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

  def semaphore(0, cnt) do
    receive do
      :release ->
        semaphore(1, cnt)
    end
  end

  def semaphore(n, cnt) do
    receive do
      {:acquire, from} ->
        send(from, :granted)
        semaphore(n - 1, cnt)

      :release ->
        if n < cnt do
          semaphore(n + 1, cnt)
        else
          semaphore(n, cnt)
        end
    end
  end
end
