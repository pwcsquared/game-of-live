defmodule GameOfLife.Server do
  use GenServer

  alias GameOfLife.Board, as: GameBoard

  def start_link(board_width) do
    GenServer.start_link(__MODULE__, board_width)
  end

  def advance(pid) do
    GenServer.call(pid, :advance)
  end

  def get(pid) do
    pid
    |> GenServer.call(:get)
    |> GameBoard.to_list()
  end

  @impl true
  def init(board_width) do
    game_board = GameBoard.new() |> GameBoard.populate(board_width)
    state = %{board_width: board_width, history: [game_board]}
    {:ok, state}
  end

  @impl true
  def handle_call(:advance, _from, %{board_width: width, history: board_history} = state) do
    next_board = board_history |> hd() |> GameBoard.advance(width)
    {:reply, next_board, Map.put(state, :history, [next_board | board_history])}
  end

  @impl true
  def handle_call(:get, _from, %{history: [board | _]} = state) do
    {:reply, board, state}
  end
end
