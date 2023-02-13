defmodule Averager do
  def start do
    spawn(__MODULE__, :loop, [0, 0])
  end

  def kill, do: exit(:normal)

  def loop(sum, cnt) do
    receive do
      nr when is_float(nr) or is_integer(nr) ->
        new_sum = sum + nr
        new_count = cnt + 1
        new_avg = new_sum / new_count
        IO.puts("Curavg: #{new_avg} #{new_sum} #{new_count}")
        loop(new_sum, cnt + 1)

      _ ->
        exit(:illegal_arg)
    end
  end
end
