defmodule StarWars.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  def encode(data) do
    data |> Jason.encode!() |> Jason.Formatter.pretty_print()
  end

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
end
