defmodule IslandsEngine.Island do
  alias __MODULE__
  alias IslandsEngine.Coordinate

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  # WITH EXAMPLE FROM DOCS
  #   opts = %{width: 10, height: 15}
  # with {:ok, width} <- Map.fetch(opts, :width),
  #      {:ok, height} <- Map.fetch(opts, :height) do
  #   {:ok, width * height}
  # end
  # {:ok, 150}

  def new(type, %Coordinate{} = upper_left) do
    #  [_ | _] = offsets is pattern matching
    with [_ | _] = offsets <- offsets(type),
         # %MapSet{} = coordinates is pattern matching
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 1}, {2, 0}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}

  # def reduce_while(enumerable, acc, fun)
  #  iex> Enum.reduce_while(1..100, 0, fn x, acc ->
  # ...>   if x > 0, do: {:cont, acc + x}, else: {:halt, acc}
  # ...> end)
  # 5050

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end
end

# INSIDE IEX
# iex(9)> alias IslandsEngine.{Coordinate, Island}

# iex(10)> {:ok, coordinate} = Coordinate.new(4, 6)
# {:ok, %IslandsEngine.Coordinate{row: 4, col: 6}}

# iex(11)> Island.new(:l_shape, coordinate)
# {:ok,
#  %IslandsEngine.Island{
#    coordinates: MapSet.new([
#      %IslandsEngine.Coordinate{row: 4, col: 6},
#      %IslandsEngine.Coordinate{row: 5, col: 6},
#      %IslandsEngine.Coordinate{row: 6, col: 6},
#      %IslandsEngine.Coordinate{row: 6, col: 7}
#    ]),
#    hit_coordinates: MapSet.new([])
#  }}

# iex(12)> {:ok, coordinate} = Coordinate.new(10, 10)
# {:ok, %IslandsEngine.Coordinate{row: 10, col: 10}}

# iex(13)> Island.new(:l_shape, coordinate)
# {:error, :invalid_coordinate}
