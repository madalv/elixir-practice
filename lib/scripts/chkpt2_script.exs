import Practice

# checkpoint 2 min tasks
IO.puts("----- MIN -----")

IO.puts(is_prime?(13))
IO.puts(is_prime?(220))

IO.puts(cylinder_area(9, 3))

IO.inspect(reverse_list([1, 2, 3, 4]))

IO.puts(sum_unique_elements([1, 2, 4, 8, 4, 2]))

IO.inspect(extract_random([1, 3, 4, 2, 2], 3))

IO.inspect(get_n_fib(6))

map = %{"tree" => "copac", "sun" => "soare", "death" => "moarte"}
string = "Sitting under a tree looking up at the sun thinking of death"

IO.puts(translate(map, string))

IO.puts(smallest_possible_nr(1, 0, 4))

IO.inspect(rotate_left([1, 2, 3, 5], 2))

IO.inspect(pythagorean_triple(20))

# checkpoin4 2 main tasks
IO.puts("----- MAIN -----")

IO.inspect(line_words(["Hello", "Alaska", "Dad", "Peace"]))

IO.inspect(caesar_encode("abc", 1))
IO.inspect(caesar_decode("zab", 1))

IO.inspect(letters_combos("292"))

IO.inspect(rm_consecutive_duplicates([1, 2, 3, 3, 4, 4, 5]))

IO.inspect(group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))

# checkpoint 2 bonus tasks
IO.puts("----- BONUS -----")

IO.inspect(longest_common_prefix(["flower", "flow", "flight"]))
IO.inspect(longest_common_prefix(["flower", "alpha", "bat"]))

IO.inspect(to_roman(13))

IO.inspect(factorize(21))
IO.inspect(factorize(36), charlists: :as_list)
IO.inspect(factorize(13), charlists: :as_list)
