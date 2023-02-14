defmodule MyNode do
  def start(prev, val, next) do
    spawn(__MODULE__, :loop, [prev, val, next])
  end

  def set_next(pid, next) do
    send(pid, {:set_next, next})
  end

  def set_prev(pid, prev) do
    send(pid, {:set_prev, prev})
  end

  def loop(prev, val, next) do
    receive do
      :next ->
        IO.inspect(val)
        if next != nil, do: send(next, :next)

      :prev ->
        IO.inspect(val)
        if prev != nil, do: send(prev, :prev)

      {:set_next, new_next} ->
        loop(prev, val, new_next)

      {:set_prev, new_prev} ->
        loop(new_prev, val, next)

      :reverse ->
        loop(next, val, prev)
      :show ->
        IO.inspect(prev)
        IO.inspect(next)
    end
    loop(prev, val, next)
  end
end
