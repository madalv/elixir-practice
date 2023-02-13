s = Semaphore.create_semaphore(1)

spawn(fn ->
  Semaphore.request(s)
    IO.puts("Free to go")
    #send(s, :release)
end)

spawn(fn ->
  Semaphore.request(s)
    IO.puts("Free 2 go")
end)
