defmodule IslandsEngine.Coordinate do
  alias IslandsEngine.Coordinate
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]
  @board_range 1..10

  @spec new(number, number) :: {:error, atom()} | {:ok, struct()}
  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
