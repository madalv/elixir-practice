defmodule Printer do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def kill, do: exit(:normal)

  def loop do
    receive do
      {_, string} -> IO.puts("Received: \"#{string}\"")
    end

    loop()
  end
end
