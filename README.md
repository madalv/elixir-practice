# Lab 1 PTR
 
## Running the Scripts

Each week has a folder named `scripts`. 
To run the tasks for a particular week, change into the root folder and execute:

```bash
mix run lib/week2/scripts/chkpt2_script.exs
```

This will execute script `chkpt2_script.exs`, which contains tasks for Week 2. 


Alternatively, to start Elixir's interactive shell loaded with the project execute (from the root folder):

```bash
iex -S mix
```

## Testing

To test, execute:

```bash
mix test
```

## Formatting

To format, execute:

```bash
mix format
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `practice` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:practice, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/practice](https://hexdocs.pm/practice).

