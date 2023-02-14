s = Semaphore.create_semaphore(1)

spawn(fn ->
  Semaphore.acquire(s)
  IO.puts("Free to go")
  #Semaphore.release(s)
end)

spawn(fn ->
  Semaphore.acquire(s)
  IO.puts("Free 2 go")
end)
