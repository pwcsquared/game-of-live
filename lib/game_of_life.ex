defmodule GameOfLife do
  @moduledoc """
  GameOfLife keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Creates a randomized Game of Life board.
  The data structure is a MapSet where the values are tuples of {x, y}.
  """
  def create_gameboard(board_width) do
    board_width
    |> generate_coord_pairs()
    |> Enum.reduce(MapSet.new(), fn coord_pair, board ->
      if bool_int() === 1 do
        MapSet.put(board, coord_pair)
      else
        board
      end
    end)
  end

  def advance_gameboard(board, board_width) do
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

  def start_game(width) do
    GameOfLife.Server.start_link(width)
  end

  def get_board_data() do
    GameOfLife.Server.get() |> to_list()
  end

  def advance() do
    GameOfLife.Server.advance()
  end

  def generate_coord_pairs(board_width) do
    coord_range = 0..(board_width - 1)
    for x <- coord_range, y <- coord_range, do: {x, y}
  end

  @doc """
  Converts the MapSet into a list of coordinate pairs lists for sending to client.
  """
  def to_list(board), do: Enum.map(board, &Tuple.to_list(&1))

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
