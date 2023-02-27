defmodule IslandsEngine.Guesses do
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  def new() do
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}
  end
end

# INSIDE IEX
# iex(1)> alias IslandsEngine.{Coordinate, Guesses}
# iex(2)> guesses = Guesses.new()
# iex(3)> {:ok, coord1} = Coordinate.new(1,1)
# iex(4)> {:ok, coord2} = Coordinate.new(2,2)
# iex(5)> guesses = update_in(guesses.hits, &MapSet.put(&1, coord1))
# iex(6)> guesses = update_in(guesses.hits, &MapSet.put(&1, coord2))
# iex(7)> guesses = update_in(guesses.hits, &MapSet.put(&1, coord1))
# %IslandsEngine.Guesses{
#   hits: MapSet.new([
#     %IslandsEngine.Coordinate{row: 1, col: 1},
#     %IslandsEngine.Coordinate{row: 2, col: 2}
#   ]),
#   misses: MapSet.new([])
# }
