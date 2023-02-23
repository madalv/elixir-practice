StringSupervisor.start_link()
StringSupervisor.start_processing("Bruh WHY must we suffer in this way? You nomster!")

receive do
  msg -> IO.inspect(msg)
end
