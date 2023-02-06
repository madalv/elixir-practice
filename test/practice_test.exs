defmodule PracticeTest do
  use ExUnit.Case
  doctest Practice

  test "check hello string" do
    assert Practice.get_hello_str() == "Hello PTR"
  end
end
