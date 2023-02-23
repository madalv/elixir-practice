# StringSupervisor.start_link()
# StringSupervisor.process("Bruh WHY must we suffer in this way? You nomster!")

{:ok, s} = WorkerSupervisor.start_link(4)
IO.inspect(Supervisor.which_children(s))

Week4.Worker.work(
  WorkerSupervisor.get_process(:worker1),
  "hello world"
)

Week4.Worker.die(WorkerSupervisor.get_process(:worker1))

receive do
  msg -> IO.inspect(msg)
end
