defmodule GameOfLife.Board do
  @moduledoc """
  Contains functions for creating and advancing the game board.
  """

  @type t :: MapSet.t()

  def new(), do: MapSet.new()

  @doc """
  Populates a game board with random living cells.
  The data structure is a MapSet where the values are tuples of living cells at coordinates {x, y}.
  """
  def populate(board, board_width) do
    board_width
    |> generate_coord_pairs()
    |> Enum.reduce(board, fn coord_pair, board ->
      if bool_int() === 1 do
        MapSet.put(board, coord_pair)
      else
        board
      end
    end)
  end

  @doc """
  Reads in a board state and creates a new board generation.
  """
  def advance(board, board_width) do
    board_width
    |> generate_coord_pairs()
    |> Enum.reduce(MapSet.new(), fn coords, new_board ->
      if cell_lives?(MapSet.member?(board, coords), live_neighbor_count(coords, board)) do
        MapSet.put(new_board, coords)
      else
        new_board
      end
    end)
  end

  @doc """
  Converts the Board into a list of coordinate pairs lists.

  iex> board = MapSet.new([{0, 0}, {1, 0}, {1, 1}])
  iex> GameOfLife.Board.to_list(board)
  [[0, 0], [1, 0], [1, 1]]
  """
  def to_list(board), do: Enum.map(board, &Tuple.to_list(&1))

  def generate_coord_pairs(board_width) do
    coord_range = 0..(board_width - 1)
    for x <- coord_range, y <- coord_range, do: {x, y}
  end

  defp cell_lives?(true, 2), do: true
  defp cell_lives?(true, 3), do: true
  defp cell_lives?(false, 3), do: true
  defp cell_lives?(_, _), do: false

  defp live_neighbor_count({x, y}, board) do
    {x, y}
    |> neighbors_of()
    |> Enum.reduce_while(0, fn neighbor, acc ->
      if MapSet.member?(board, neighbor) do
        {:cont, acc + 1}
      else
        {:cont, acc}
      end
    end)
  end

  defp neighbors_of({x, y}) do
    [
      {x, y + 1},
      {x, y - 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x - 1, y - 1}
    ]
  end

  defp bool_int(), do: :rand.uniform() |> round()
end
