defmodule GameOfLife do
  @moduledoc """
  GameOfLife keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Creates a randomized Game of Life board.
  The data structure is a map where the keys are tuples of {x, y}.
  """
  def create_gameboard(board_width) do
    coords = Enum.to_list(0..board_width)

    coords
    |> Enum.reduce(%{}, fn x, game_board ->
      coord_pairs = Enum.zip(Stream.cycle([x]), coords)
      Enum.with_index(coord_pairs)
      for pair <- coord_pairs, into: game_board, do: {pair, bool_int()}
    end)
  end

  @doc """
  Characteristics of the optimal data structure:
  Needs quick lookup for finding neighboring cells. 
  Has to be able to convert to a list of coordinates quickly.
  """
  def create_optimized_gameboard(width) do
  end

  def remove_dead_cells(game_board) do
    Enum.reduce(game_board, [], fn
      {{x, y}, 1}, acc -> [[x, y] | acc]
      {_, 0}, acc -> acc
    end)
  end

  def advance_board(board) do
    Enum.reduce(board, %{}, fn
      {coords, 1}, new_board ->
        Map.put(new_board, coords, maybe_kill_cell(neighbors_of(coords, board)))

      {coords, 0}, new_board ->
        Map.put(new_board, coords, maybe_live_cell(neighbors_of(coords, board)))
    end)
  end

  defp maybe_kill_cell(2), do: 1
  defp maybe_kill_cell(3), do: 1
  defp maybe_kill_cell(_), do: 0

  defp maybe_live_cell(3), do: 1
  defp maybe_live_cell(_), do: 0

  defp neighbors_of({x, y}, board) do
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
    |> Enum.reduce(0, fn neighbor, acc -> Map.get(board, neighbor, 0) + acc end)
  end

  defp bool_int(), do: :rand.uniform() |> round()
end
