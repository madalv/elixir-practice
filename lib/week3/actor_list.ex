defmodule ActorList do

  def create_dll(list) do

  end

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
