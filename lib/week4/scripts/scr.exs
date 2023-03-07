# StringSupervisor.start_link()
# StringSupervisor.process("Bruh WHY must we suffer in this way? You nomster!")

{:ok, s} = WorkerSupervisor.start_link(4)
IO.inspect(Supervisor.which_children(s))

Week4.Worker.work(
  WorkerSupervisor.get_process(:worker1),
  "hello world"
)

# Week4.Worker.die(WorkerSupervisor.get_process(:worker1))

# ###

# # {:ok, s} = MainSupervisor.start_link()
# # Process.exit(MainSupervisor.get_process(:cabin_sensor), :a)

# ###

# # {:ok, s} = PulpFiction.Supervisor.start_link()
# # WhiteGuy.speak("W-What...?")

# Process.info(Process.whereis(CrashCounter))

receive do
  msg -> IO.puts(msg)
end
