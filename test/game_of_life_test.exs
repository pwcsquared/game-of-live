defmodule GameOfLifeTest do
  use ExUnit.Case, async: true
  doctest GameOfLife

  test "generates coordinate pairs from board width" do
    assert GameOfLife.generate_coord_pairs(3) == [
             {0, 0},
             {0, 1},
             {0, 2},
             {1, 0},
             {1, 1},
             {1, 2},
             {2, 0},
             {2, 1},
             {2, 2}
           ]
  end
end
