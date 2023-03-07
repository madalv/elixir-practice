# FAF.PTR16.1 -- Project 0
> **Performed by:** Magal Vlada, group FAF-203
> **Verified by:** asist. univ. Alexandru Osadcenco

## P0W1

The first week was for installing Elixir, creating a repository, and writing some simple code.

Here is the code for printing `Hello PTR` and the unit test required:

```elixir
  test "check hello string" do
    assert Practice.get_hello_str() == "Hello PTR"
  end

    def get_hello_str() do
    "Hello PTR"
  end
```

## P0W2

**Miminal Tasks**

Since there are way too many functions to comment them all, I will a randomlu pick one to comment: `rotate_left`. It works by first separating the list into the head (first element) and tail, the calls itself recursively with the new list being
the old list with the head moved to the back (in other words the head is rotated left for count `n` times).


```elixir
  def is_prime?(n) when n in [1, 2, 3], do: true

  def is_prime?(n) when is_integer(n) do
    sqrt = :math.sqrt(n) |> Float.floor() |> round
    !Enum.any?(2..sqrt, fn x -> rem(n, x) == 0 end)
  end

  def cylinder_area(h, r) do
    2 * :math.pi() * (r * h + :math.pow(r, 2))
  end

  def reverse_list([]), do: []

  def reverse_list([head | tail]) do
    reverse_list(tail) ++ [head]
  end

  def sum_unique_elements(list)
      when is_list(list) do
    list |> Enum.uniq() |> Enum.sum()
  end

  def extract_random(list, count)
      when is_list(list) and
            is_integer(count) do
    list |> Enum.shuffle() |> Enum.take(count)
  end

  def get_n_fib(n) do
    fib([1, 1], n)
  end

  defp fib(list, n) do
    new_list = list ++ [Enum.take(list, -2) |> Enum.sum()]

    cond do
      length(new_list) == n -> new_list
      length(new_list) < n -> fib(new_list, n)
    end
  end

  def translate(map, string)
      when is_map(map) do
    string
    |> String.split(" ")
    |> Enum.map(fn word -> Map.get(map, word, word) end)
    |> Enum.join(" ")
  end

  def smallest_possible_nr(a, b, c) do
    list = [a, b, c]

    zero_count =
      Enum.reduce(list, 0, fn dig, acc ->
        if dig == 0 do
          acc + 1
        else
          acc
        end
      end)

    list
    |> Enum.filter(fn dig -> dig != 0 end)
    |> Enum.sort()
    |> add_zeroes(zero_count)
    |> Enum.join()
  end

  defp add_zeroes(list, count), do: List.insert_at(list, 1, replicate("0", count))

  defp replicate(n, count), do: for(_ <- 1..count, do: n)

  def rotate_left(list, 0), do: list

  def rotate_left(list, n) do
    [head | tail] = list
    rotate_left(tail ++ [head], n - 1)
  end

  def pythagorean_triple(n) do
    for a <- 1..n,
        b <- (a + 1)..n,
        c <- (b + 1)..n,
        a * a + b * b == c * c,
        do: {a, b, c}
  end
```


**Main Tasks**

Functions are as follows:

* `line_words(list)` - first set up all rows. Split each words into unique letters, then check if any rows contains all letters; if yes, keep word.
* `caesar_encode(string, key)` - for each char of string check if it is a letter (c > 97) and modify using some formula found on forums. 
* `caesar_decode(string, key)` - same process as encoding but with negated key.
* `rm_consecutive_duplicates(list)` - separate list into head/tail. If head equals to 1st tail element, head needs to be removed, so you call the function recursively with only the tail. Otherwise, keep the head and and "deal" with the tail.
* `group_anagrams(list)` - sort each word and add the original word to the map entry equal to the sorted word.

```elixir
  def line_words(list) do
    row1 = ["q", "w", "e", "r", "y", "u", "i", "o", "p"]
    row2 = ["a", "s", "d", "f", "g", "h", "j", "k", "k", "l"]
    row3 = ["z", "x", "c", "v", "b", "n", "m"]

    list
    |> Enum.filter(fn word ->
      letters =
        word
        |> String.downcase()
        |> String.split("", trim: true)
        |> Enum.uniq()

      letters -- row1 == [] || letters -- row2 == [] || letters -- row3 == []
    end)
  end

  def caesar_encode(string, key) do
    s =
      for c <- Kernel.to_charlist(string),
          do: (c < 97 && c) || 97 + rem(c - 71 - key, 26)

    to_string(s)
  end

  def caesar_decode(string, key), do: caesar_encode(string, -key)

  def rm_consecutive_duplicates([]), do: []

  def rm_consecutive_duplicates(list) do
    [head | tail] = list

    cond do
      head == Enum.at(tail, 0) ->
        rm_consecutive_duplicates(tail)

      head != Enum.at(tail, 0) ->
        [head | rm_consecutive_duplicates(tail)]
    end
  end

  def group_anagrams(list) do
    map =
      Enum.reduce(list, %{}, fn word, acc ->
        sorted_word = word |> String.split("", trim: true) |> Enum.sort() |> Enum.join("")
        existing_words = Map.get(acc, sorted_word, "")

        cond do
          existing_words == "" ->
            Map.put(acc, sorted_word, [word])

          existing_words != "" ->
            Map.put(acc, sorted_word, [word | existing_words])
        end
      end)

    map
  end
```

**Bonus Tasks**

These would take also way too long to explain, so I'll comment the hardest one, `letters_combos(string)`. First the map of numbers to list of letters is set up. Then a set of letters lists is created from the given number sequence. For example `"234" =>[["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]]`. 

Then comes the fun part: recursion. There's the function `combine` which -- you guessed it -- combines the lists. This function takes as input the first of the lists (in our example `["a", "b", "c"]`) and the tail - the to-combine lists (`[["d", "e", "f"], ["g", "h", "i"]]`). Then it combines elements of the first list given as input and the head of the to-combine list given as second input. So in our case the result would be `["ad", "ae", "af", "bd", ..., "cf"]`.

Then, it removes the head from the to-combine list (after all, it had just been combined) and calls the function with the result of the current combo and the rest of the to-combine list. So for the second call of `combine` the inputs would be `["ad", "ae", "af", "bd", ... "cf"]` and `[["g", "h", "i"]]`. The result of this combo would be `["adg", "adh", "adi", "aeg", ..., "cfi" ]`. Then the to-combine list would be empty and that means we just return the last result we got 'cause we've combined all the lists.

```elixir
def longest_common_prefix(strings) do
    strings
    |> Enum.map(fn string -> Kernel.to_charlist(string) end)
    |> Enum.zip()
    |> Enum.map(fn tuple -> Tuple.to_list(tuple) end)
    |> Enum.map(fn part -> Enum.uniq(part) end)
    |> Enum.take_while(fn part -> length(part) == 1 end)
    |> Enum.join("")
  end

  def to_roman(nr) do
    romans = [
      {1000, "M"},
      {900, "CM"},
      {500, "D"},
      {400, "CD"},
      {100, "C"},
      {90, "XC"},
      {50, "L"},
      {40, "XL"},
      {10, "X"},
      {9, "IX"},
      {5, "V"},
      {4, "IV"},
      {1, "I"}
    ]

    get_roman_numeral(nr, romans)
  end

  defp get_roman_numeral(0, _), do: ""

  defp get_roman_numeral(nr, [{key, val} | tail]) do
    count = div(nr, key)
    String.duplicate(val, count) <> get_roman_numeral(nr - key * count, tail)
  end

  def factorize(n) do
    if is_prime?(n) do
      [n]
    else
      Enum.reduce(2..div(n, 2), [], fn i, acc ->
        cond do
          rem(n, i) == 0 && is_prime?(i) ->
            acc ++ find_factors(n, i)

          true ->
            acc
        end
      end)
    end
  end

  defp find_factors(n, i) do
    cond do
      rem(n, i) == 0 && is_prime?(i) ->
        [i | find_factors(div(n, i), i)]

      true ->
        []
    end
  end

  def letters_combos(string) do
    map = %{
      "2" => ["a", "b", "c"],
      "3" => ["d", "e", "f"],
      "4" => ["g", "h", "i"],
      "5" => ["j", "k", "l"],
      "6" => ["m", "n", "o"],
      "7" => ["p", "q", "r", "s"],
      "8" => ["t", "u", "v"],
      "9" => ["w", "x", "y", "z"]
    }

    lists =
      string
      |> String.split("", trim: true)
      |> Enum.map(fn digit -> Map.get(map, digit, "") end)

    combine(Enum.at(lists, 0), List.delete_at(lists, 0))
  end

  defp combine(list, []), do: list

  defp combine(list, [head | tail]) do
    combinations = for part1 <- list, part2 <- head, do: part1 <> part2

    combine(combinations, tail)
  end
end
```

## POW3

**Minimal Tasks**

* Actor that prints any message it receives:

```elixir
defmodule Printer do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def kill, do: exit(:normal)

  def loop do
    receive do
      {_, string} -> IO.puts("Received: \"#{string}\"")
    end

    loop()
  end
end
```

* Actor that modifies messages it receives:

```elixir
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
```

* Two actors monitoring each other. 
  
The Monitor is used to monitor any other process, by calling `Monitor.monitor()`. It is implemented using GenServer. Check example below.
```elixir
defmodule Monitor do
  use GenServer
  require Logger

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def monitor(mon_pid, pid) do
    GenServer.cast(mon_pid, {:monitor, pid})
  end

  def handle_cast({:monitor, pid}, state) do
    Process.monitor(pid)
    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, _, reason}, state) do
    Logger.info("Monitored process down. Reason: #{Atom.to_string(reason)}")
    {:noreply, state}
  end
end
```

```elixir
modifier = Modifier.start()

{:ok, modifier_monitor} = Monitor.start_link([])
Monitor.monitor(modifier_monitor, modifier)
```


**Main Tasks**

* Queue actor with API helper functions.

As you can see, the actor has helper functions (`pop`, `push`, etc.) which send messages to itself. I've learned more about GenServer behaviour from this task.

```elixir
defmodule Queue do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def push(queue_pid, item) do
    GenServer.cast(queue_pid, {:push, item})
  end

  def pop(queue_pid) do
    GenServer.call(queue_pid, :pop)
  end

  def list(queue_pid) do
    GenServer.call(queue_pid, :list)
  end

  def init(queue) do
    {:ok, queue}
  end

  def handle_call(:pop, _from, []) do
    # :reply, reply, new_state
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, queue) do
    # :reply, reply, new_state
    {:reply, List.last(queue), List.delete_at(queue, -1)}
  end

  # call = sync, cast = async
  def handle_call(:list, _from, queue) do
    # :reply, reply, new_state
    {:reply, queue, queue}
  end

  def handle_cast({:push, item}, queue) do
    {:noreply, [item | queue]}
  end
end
```

* Semaphore.

On acquire, the actor sends a message to itself, which is granted if there are permits available and the number of permits is reduced by 1. If the number of permits reach 0, the actor is blocked in waiting for a release message, which bumps the nr of free permits back to 1.

```elixir
defmodule Semaphore do
  def create_semaphore(count \\ 1) do
    spawn(Semaphore, :semaphore, [count, count])
  end

  def release(semaphore) do
    send(semaphore, :release)
  end

  def acquire(semaphore) do
    send(semaphore, {:acquire, self()})

    receive do
      :granted ->
        :ok
    end
  end

  def semaphore(0, cnt) do
    receive do
      :release ->
        semaphore(1, cnt)
    end
  end

  def semaphore(n, cnt) do
    receive do
      {:acquire, from} ->
        send(from, :granted)
        semaphore(n - 1, cnt)

      :release ->
        if n < cnt do
          semaphore(n + 1, cnt)
        else
          semaphore(n, cnt)
        end
    end
  end
end
```

How to use:

```elixir
s = Semaphore.create_semaphore(1)

spawn(fn ->
  Semaphore.acquire(s)
  IO.puts("Free to go")
  Semaphore.release(s)
end)

spawn(fn ->
  Semaphore.acquire(s)
  IO.puts("Gotta wait")
end)
```


**Bonus Tasks**

* Scheduler actor that creates nodes to complete risky biz.

On receiving task, the Scheduler creates a worker and starts monitoring. If it receives a message saying the worker died, it considers the job done if it died for a normal reason, else it creates a new node for the job.

Scheduler:
```elixir
defmodule Scheduler do
  def start do
    spawn(__MODULE__, :loop, [[]])
  end

  def schedule(pid, task) do
    send(pid, {:task, task})
  end

  def create_worker() do
    worker = Worker.start()
    Process.monitor(worker)
    worker
  end

  def schedule_worker(task, worker) do
    send(worker, {:task, task})
  end

  def loop(list) do
    receive do
      {:task, task} ->
        schedule_worker(task, create_worker())
        loop(list)

      {:DOWN, _, :process, _, reason} ->
        case reason do
          :normal ->
            IO.puts("Task successful: Miau")

          _ ->
            task = Atom.to_string(reason)
            IO.puts("Task failed: #{task}")
            schedule_worker(task, create_worker())
            loop(list)
        end
    end
  end
end
```

Worker:
```elixir
defmodule Worker do
  def start() do
    spawn(__MODULE__, :loop, [])
  end

  def loop() do
    receive do
      {:task, task} ->
        if :rand.uniform(2) == 1 do
          exit(:normal)
        else
          exit(String.to_atom(task))
        end
    end
  end
end
```



* Doubly linked list with actors.

Nodes can receive messages to set their previous and next actors, to iterate, and reverse its neighbors.
```elixir
defmodule MyNode do
  def start(prev, val, next) do
    spawn(__MODULE__, :loop, [prev, val, next])
  end

  def set_next(pid, next) do
    send(pid, {:set_next, next})
  end

  def set_prev(pid, prev) do
    send(pid, {:set_prev, prev})
  end

  def loop(prev, val, next) do
    receive do
      :next ->
        IO.inspect(val)
        if next != nil, do: send(next, :next)

      :prev ->
        IO.inspect(val)
        if prev != nil, do: send(prev, :prev)

      {:set_next, new_next} ->
        loop(prev, val, new_next)

      {:set_prev, new_prev} ->
        loop(new_prev, val, next)

      :reverse ->
        loop(next, val, prev)

      :show ->
        IO.inspect(prev)
        IO.inspect(next)
    end

    loop(prev, val, next)
  end
end
```

The ActorList module can be used to traverse the list (send a iteration message to the first actor) and reversing it.

```elixir
defmodule ActorList do
  def traverse(list) do
    send(Enum.at(list, 0), :next)
  end

  def reverse(list) do
    Enum.map(list, fn actor ->
      send(actor, :reverse)
      actor
    end)

    Enum.reverse(list)
  end
end
```

## P0W4

**Minimal Tasls**

* Identical pool of supervised actos.

The Supervisor receives the nr of children as initial argument. It creates the required number of children and gives them all IDs (to be able to address them later, with `get_process`).

```elixir
defmodule WorkerSupervisor do
  use Supervisor
  require Logger

  def start_link(nr) do
    Supervisor.start_link(__MODULE__, nr, name: __MODULE__)
  end

  def init(nr) do
    Process.flag(:trap_exit, true)

    children =
      for i <- 1..nr,
          do: %{
            id: String.to_atom("worker#{i}"),
            start: {Week4.Worker, :start_link, [[]]}
          }

    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_process(atom) do
    Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {id, _, _, _} -> id == atom end)
    |> elem(1)
  end
end
```
The Worker just echoes any message, except for the "die" one, in which case it... kills itself (much like I want to do writing this goddamned report at 00:14).

```elixir
defmodule Week4.Worker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(pid, string) do
    GenServer.call(pid, string)
  end

  def die(pid) do
    Process.exit(pid, :die)
  end

  def handle_call(string, _from, _state) do
    {:reply, string, string}
  end

  def terminate(_reason, state) do
    Logger.debug("Worker #{inspect(self())} down #{inspect(state)}")
  end
end
```

**Main Tasks**

* Supervised string processing line.

The Supervisor completes the processing. If any worker dies, all of them are restarted.

```elixir
defmodule StringSupervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      Splitter,
      Swapper,
      Joiner
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def process(string) do
    string
    |> Splitter.work()
    |> Swapper.work()
    |> Joiner.work()
  end
end
```

Workers:

```elixir
defmodule Splitter do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(string) do
    GenServer.call(__MODULE__, string)
  end

  def handle_call(string, _from, _state) do
    split = String.split(string, " ", trim: true)
    {:reply, split, string}
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Splitter #{inspect(state)}")
  end
end

defmodule Swapper do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def work(list) do
    GenServer.call(__MODULE__, list)
  end

  def handle_call(list, _from, _state) do
    Logger.debug("Swapper got: " <> inspect(list))

    if :rand.uniform(2) == 1 do
      exit(:random_failure)
    else
      modified =
        list
        |> Enum.map(fn word ->
          word
          |> String.downcase()
          |> String.split("", trim: true)
          |> Enum.map(fn c ->
            case c do
              "m" -> "n"
              "n" -> "m"
              c -> c
            end
          end)
          |> Enum.join("")
        end)

      {:reply, modified, list}
    end
  end

  def terminate(_reason, state) do
    Logger.debug("Going down Swapper #{inspect(state)}")
  end
end

```

**Bonus Tasks**

* Car sensor system.

The MainSupervisor starts all the sensors, and the crash counter (which counts crashes and notified the MainSupervisor when to deploy airbags).

```elixir
defmodule MainSupervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      CrashCounter,
      WheelSupervisor,
      %{
        id: :cabin_sensor,
        start: {Sensor, :start_link, ["Cabin Sensor"]}
      },
      %{
        id: :motor_sensor,
        start: {Sensor, :start_link, ["Motor Sensor"]}
      },
      %{
        id: :chassis_sensor,
        start: {Sensor, :start_link, ["Chassis Sensor"]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def deploy_airbag() do
    Logger.warn("DEPLOYING AIRBAGS.")
  end

  def get_process(atom) do
    Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {id, _, _, _} -> id == atom end)
    |> elem(1)
  end
end
```

```elixir
defmodule CrashCounter do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def new_crash() do
    GenServer.cast(__MODULE__, {:new_crash})
  end

  def notify_supervisor() do
    MainSupervisor.deploy_airbag()
  end

  def handle_cast({:new_crash}, state) do
    Logger.debug("New crash detected. Crash cnt #{state + 1} / 2")

    if state + 1 >= 2 do
      notify_supervisor()
      {:noreply, state + 1}
    else
      {:noreply, state + 1}
    end
  end
end
```

WheelSupervisor restarts wheels if needed. 

```elixir
defmodule WheelSupervisor do
  use Supervisor
  require Logger

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      %{
        id: :wheel1_sensor,
        start: {Sensor, :start_link, ["Wheel 1 Sensor"]}
      },
      %{
        id: :wheel2_sensor,
        start: {Sensor, :start_link, ["Wheel 2 Sensor"]}
      },
      %{
        id: :wheel3_sensor,
        start: {Sensor, :start_link, ["Wheel 3 Sensor"]}
      },
      %{
        id: :wheel4_sensor,
        start: {Sensor, :start_link, ["Wheel 4 Sensor"]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_process(atom) do
    Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {id, _, _, _} -> id == atom end)
    |> elem(1)
  end
end
```

Sensor just notify CrashCounter in their `terminate` callback.

```elixir
defmodule Sensor do
  use GenServer
  require Logger

  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    Logger.info("#{init_arg} starting...")
    {:ok, init_arg}
  end

  def handle_info({:EXIT, _from, reason}, state) do
    Logger.warn("#{state} detected a failure!")
    {:stop, reason, state}
  end

  def terminate(_reason, _state) do
    CrashCounter.new_crash()
  end
end
```

* Iconic Pulp Fiction scene recreation.

So we got Jules, White Guy, and a Supervisor responsible for recreating either of them and restarting the process.

Jules asks the first of his lines when started, then waits for White Guy's answer before replying. White Guy dies if either Jules counts up 5 "What"s or he reached the end of his lines.

```elixir
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

```

```elixir
defmodule WhiteGuy do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def speak(line) do
    GenServer.cast(__MODULE__, {:speak, line})
  end

  def handle_cast({:speak, line}, state) do
    JulesWinnfield.speak(line)
    {:noreply, state}
  end

  def kill() do
    GenServer.cast(__MODULE__, :die)
  end

  def handle_cast(:die, state) do
    {:stop, :gunshot, state}
  end
end

```

```elixir
defmodule PulpFiction.Supervisor do
  use Supervisor
  require Logger

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    children = [
      JulesWinnfield,
      WhiteGuy
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
```

## P0W5

**Minimal Tasks**
 
* Application that would:
  * visit the quotes link and print response;
  * extract quotes to list of maps;
  * persists quotes to json.

As you can see, HTTPoison is used to get the HTML, then it is parsed using Floki. Tags and the author are extracted from each quote and added to the map. Lastly, `save_json` persists the extracted quotes to a JSON file.

```elixir
defmodule Quotes do
  def get_quotes do
    response = HTTPoison.get!("https://quotes.toscrape.com/")

    response.body
    |> Floki.find(".quote")
    |> Enum.map(fn div ->
      %{
        quote: get_quote(div),
        author: get_author(div),
        tags: get_tags(div)
      }
    end)
  end

  def get_quote(div) do
    div
    |> Floki.find(".text")
    |> Floki.text()
  end

  def get_author(div) do
    div
    |> Floki.find(".author")
    |> Floki.text()
  end

  def get_tags(div) do
    div
    |> Floki.find(".tag")
    |> Enum.map(fn tag ->
      Floki.text(tag)
    end)
  end

  def save_json() do
    data = get_quotes() |> Jason.encode!() |> Jason.Formatter.pretty_print()
    File.write!("quotes.json", data)
  end
end

```

**Main Tasks**

* Star Wars API

For this I used the ETS (a built-in in-memory storage).

The Application itself just starts the DB and Router:

```elixir
defmodule StarWars.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: StarWars.Router, options: [port: 8080]},
      StarWars.Db
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
```

The Router is done using Plug. It has the following endpoints:

```elixir
  get "/movies" do
    movies = StarWars.Db.get_movies()
    send_resp(conn, 200, encode(movies))
  end

  get "/movies/:id" do
    id = String.to_integer(id)
    movie = StarWars.Db.get_movie(id)

    if(movie == nil) do
      send_resp(conn, 200, encode("Movie not found"))
    else
      send_resp(conn, 200, encode(movie))
    end
  end

  post "/movies" do
    movie = for {key, val} <- conn.body_params, into: %{}, do: {String.to_atom(key), val}
    response = StarWars.Db.create_movie(movie)
    send_resp(conn, 201, encode(response))
  end

  put "/movies/:id" do
    id = String.to_integer(id)
    movie = conn.body_params
    response = StarWars.Db.update_movie(id, movie)
    send_resp(conn, 200, encode(response))
  end

  patch "/movies/:id" do
    id = String.to_integer(id)
    movie = StarWars.Db.get_movie(id)

    modified = for {key, val} <- conn.body_params, into: %{}, do: {String.to_atom(key), val}
    needed_modified = Map.take(modified, [:director, :release_year, :title])
    movie = Map.merge(movie, needed_modified)

    response = StarWars.Db.update_movie(id, movie)

    send_resp(conn, 200, encode(response))
  end

  delete "/movies/:id" do
    id = String.to_integer(id)
    StarWars.Db.delete_movie(id)
    send_resp(conn, 200, "Deleted")
  end
```

The DB uses ETS and it has a simple interface supplied by helper functions.

```elixir
defmodule StarWars.Db do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    :ets.new(:movies_table, [:set, :public, :named_table])
    :ok = load_movies_into_table(:movies_table)
    {:ok, :movies_table}
  end

  defp load_movies_into_table(table) do
    movies = ["Excluded big ass list from report"]

    Enum.each(movies, fn movie ->
      :ets.insert(table, {movie[:id], movie})
    end)

    Logger.info("DB initialized & seeded")
  end

  def handle_call(:get_movies, _from, table) do
    Logger.info("Got all movies")
    movies = for {_id, m} <- :ets.tab2list(table), do: m
    {:reply, movies, table}
  end

  def handle_call({:get_movie, id}, _from, table) do
    movies = :ets.lookup(table, id)

    if length(movies) == 0 do
      {:reply, nil, table}
    else
      {_key, movie} = List.first(movies)
      Logger.info("Got movie #{id}")
      {:reply, movie, table}
    end
  end

  def handle_call({:create_movie, movie}, _from, table) do
    id = :ets.info(table, :size) + 1
    created = Map.put(movie, :id, id)
    :ets.insert(table, {id, created})
    Logger.info("Created movie #{inspect(created)}")
    {:reply, :ok, table}
  end

  def handle_call({:update_movie, id, movie}, _from, table) do
    :ets.insert(table, {id, movie})
    Logger.info("Updated movie #{id}: #{inspect(movie)}")
    {:reply, :ok, table}
  end

  def handle_call({:delete_movie, id}, _from, table) do
    :ets.delete(table, id)
    Logger.info("Deleted movie #{id}")
    {:reply, :ok, table}
  end

  def get_movies do
    GenServer.call(__MODULE__, :get_movies)
  end

  def get_movie(id) do
    GenServer.call(__MODULE__, {:get_movie, id})
  end

  def create_movie(movie) do
    GenServer.call(__MODULE__, {:create_movie, movie})
  end

  def update_movie(id, movie) do
    GenServer.call(__MODULE__, {:update_movie, id, movie})
  end

  def delete_movie(id) do
    GenServer.call(__MODULE__, {:delete_movie, id})
  end
end
```

## Conclusion

Completing this lab I, of course, suffered -- I meant learned Elixir purely by reading docs. It is a truly bizarre experience when you don't find a single StackOverflow answer for the majority of the questions googled. 

It was also interesting learning about the Actor Model and dealing with immutable state and the all the other functional delicacies. I overall found Elixir and the paradigms that come with it pretty fun to play around with the exception of printing stuff. Why in God's name is printing stuff to the terminal the hardest part of Elixir?!
## Bibliography

* Elixir Documentation https://elixir-lang.org/docs.html
* Plug Documentation https://hexdocs.pm/plug/readme.html
* Floki Documentation https://github.com/philss/floki
* Jason Documentation https://hexdocs.pm/jason/Jason.html#encode/2
* Supervisor/GenServer Documentation https://hexdocs.pm/elixir/1.12/Supervisor.html
* Elixir in Action, Sasa Juric, 2019, Manning Publications
* Seven Concurrency Models in Seven Weeks (Ch. 5), Paul Butcher