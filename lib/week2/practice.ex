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
