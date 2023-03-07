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
    movies = [
      %{
        id: 1,
        title: "Star Wars: Episode IV - A New Hope",
        director: "George Lucas",
        release_year: 1977
      },
      %{
        id: 2,
        title: "Star Wars: Episode V - The Empire Strikes Back",
        director: "Irvin Kershner",
        release_year: 1980
      },
      %{
        id: 3,
        title: "Star Wars: Episode VI - Return of the Jedi",
        director: "Richard Marquand",
        release_year: 1983
      },
      %{
        id: 4,
        title: "Star Wars: Episode I - The Phantom Menace",
        director: "George Lucas",
        release_year: 1999
      },
      %{
        id: 5,
        title: "Star Wars: Episode II - Attack of the Clones",
        director: "George Lucas",
        release_year: 2002
      },
      %{
        id: 6,
        title: "Star Wars: Episode III - Revenge of the Sith",
        director: "George Lucas",
        release_year: 2005
      },
      %{
        id: 7,
        title: "Star Wars: Episode VII - The Force Awakens",
        director: "J.J. Abrams",
        release_year: 2015
      },
      %{
        id: 8,
        title: "Star Wars: Episode VIII - The Last Jedi",
        director: "Rian Johnson",
        release_year: 2017
      },
      %{
        id: 9,
        title: "Star Wars: Episode IX - The Rise of Skywalker",
        director: "J.J. Abrams",
        release_year: 2019
      },
      %{
        id: 10,
        title: "Star Wars: Episode III - Revenge of the Sith",
        director: "George Lucas",
        release_year: 2005
      },
      %{
        id: 11,
        title: "Star Wars: The Rise of Skywalker",
        director: "J. J. Abrams",
        release_year: 2019
      }
    ]

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
