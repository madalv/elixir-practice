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
