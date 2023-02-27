defmodule JulesWinnfield do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    state = %{
      lines: [
        "What country you from?!",
        "'What' ain't no country I ever heard of! They speak English in 'What'?!",
        "English, motherfucker! Do you speak it?!",
        "Then you know what I'm sayin'!",
        "Describe what Marsellus Wallace looks like!",
        "Say 'what' again! Say 'what' again, I dare ya! I double dare ya, motherfucker! Say 'what' one more goddamned time!",
        "Go on...",
        "Does he look like a bitch?!"
      ],
      line_cnt: 0,
      what_cnt: 0
    }

    Logger.info("What does Marsellus Wallace look like?!")
    {:ok, state}
  end

  def speak(line) do
    GenServer.cast(__MODULE__, {:speak, line})
  end

  def handle_cast({:speak, line}, state) do
    # Logger.debug("line #{state[:line_cnt]} what #{state[:what_cnt]}")
    cond do
      state[:line_cnt] == length(state[:lines]) ->
        WhiteGuy.kill()
        {:noreply, state}

      line == "W-What...?" ->
        Logger.info(Enum.at(state[:lines], state[:line_cnt]))
        if state[:what_cnt] + 1 >= 5, do: WhiteGuy.kill()
        {:noreply, %{state | line_cnt: state[:line_cnt] + 1, what_cnt: state[:what_cnt] + 1}}

      true ->
        Logger.info(Enum.at(state[:lines], state[:line_cnt]))
        {:noreply, %{state | line_cnt: state[:line_cnt] + 1}}
    end
  end
end
