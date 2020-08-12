defmodule GameOfLife do
  @moduledoc """
  Contains functions for interacting with an instance of the game.
  """

  def start_game(width) do
    GameOfLife.Server.start_link(width)
  end

  def get_board_data(pid) do
    GameOfLife.Server.get(pid)
  end

  def advance(pid) do
    GameOfLife.Server.advance(pid)
  end
end
