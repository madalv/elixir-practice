import Concurrency

# chkpt 3 min tasks

pid1 = spawn(&printing_actor/0)
pid2 = spawn(&modifying_actor/0)

send(pid1, {:any, "Meow"})

#:timer.sleep(2000)

send(pid1, {:any, "How's the weather up there?"})

send(pid2, {:string, "Huh?"})
send(pid2, {:integer, 12})
send(pid2, {:unkown, [1, 3]})
