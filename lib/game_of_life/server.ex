defmodule GameOfLife.Server do
  use GenServer

  def start_link(board_width) do
    GenServer.start_link(__MODULE__, board_width, name: __MODULE__)
  end

  def advance() do
    GenServer.call(__MODULE__, :advance)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(board_width) do
    game_board = GameOfLife.create_gameboard(board_width)
    state = %{board_width: board_width, history: [game_board]}
    {:ok, state}
  end

  @impl true
  def handle_call(:advance, _from, %{board_width: width, history: board_history} = state) do
    next_board = GameOfLife.advance_gameboard(hd(board_history), width)
    {:reply, next_board, Map.put(state, :history, [next_board | board_history])}
  end

  @impl true
  def handle_call(:get, _from, %{history: [board | _]} = state) do
    {:reply, board, state}
  end
end
