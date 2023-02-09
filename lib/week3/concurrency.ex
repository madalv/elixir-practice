defmodule Concurrency do

  def printing_actor do
    receive do
      {_, string} -> IO.puts("You sent: \"#{string}\"")
    end
      printing_actor()
  end

  def modifying_actor do
    receive do
      {:integer, integer} -> IO.puts(integer + 1)
      {:string, string} -> IO.puts(String.downcase(string))
      _ -> IO.puts("I don't know how to HANDLE this!")
    end
    modifying_actor()
  end

end
