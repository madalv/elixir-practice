# chkpt 3 min tasks
printer = Printer.start()
modifier = Modifier.start()

{:ok, modifier_monitor} = Monitor.start_link([])
Monitor.monitor(modifier_monitor, modifier)

send(printer, {:any, "Meow"})
send(modifier, {printer, :integer, 12})
send(modifier, {printer, :string, "Ayo"})
send(modifier, "a")

averager = Averager.start()

# can't send them at the same time cause others will get ignored?
send(averager, 25.0)
:timer.sleep(1)
send(averager, 2.0)
send(averager, 5)
send(averager, 10)

# chkpt 3 main tasks

{:ok, queue} = Queue.start_link([])

Queue.push(queue, 1)
Queue.push(queue, 2)

IO.inspect(Queue.list(queue))
IO.inspect(Queue.pop(queue))

# chkpt 3 bonus tasks
scheduler = Scheduler.start()

Scheduler.schedule(scheduler, "a")
