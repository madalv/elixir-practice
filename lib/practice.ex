defmodule Practice do
  def get_hello_str() do
    "Hello PTR"
  end

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
    [a, b, c]
    |> Enum.sort()
    |> Enum.join()
  end

  def rotate_left(list, 0), do: list

  def rotate_left(list, n) do
    [head | tail] = list
    rotate_left(tail ++ [head], n - 1)
  end

  def pythagorean_triple(n) do
    for a <- 1..(n - 2),
        b <- (a + 1)..(n - 1),
        c <- (b + 1)..n,
        a * a + b * b == c * c,
        do: {a, b, c}
  end
end
