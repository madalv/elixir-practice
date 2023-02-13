defmodule Modifier do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def kill, do: exit(:normal)

  def loop do
    receive do
      {sender, :integer, integer} ->
        send(sender, {:integer, integer + 1})

      {sender, :string, string} ->
        send(sender, {:string, String.downcase(string)})

      {sender, _} ->
        send(sender, {:string, "I don't know how to HANDLE this!"})

      _ ->
        exit(:unkown_msg)
    end

    loop()
  end
end
