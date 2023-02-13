defmodule Semaphore do
  def create_semaphore(count \\ 1) do
    spawn(Semaphore, :semaphore, [count])
  end

  def request(semaphore) do
    send(semaphore, {:request, self()})

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
      {:request, from} ->
        send(from, :granted)
        semaphore(n - 1)

      :release ->
        semaphore(n + 1)
    end
  end
end
