defmodule GameOfLifeWeb.GameLive do
  use Phoenix.LiveView

  @width 100

  def render(assigns) do
    ~L"""
    <canvas
      width="<%= @width %>"
      height="<%= @height %>"
      data-board="<%= Jason.encode!(@board) %>" 
      data-length="<%= @length %>"
      phx-hook="canvas"
    ></canvas>
    """
  end

  def mount(_params, _session, socket) do
    Agent.start_link(fn -> GameOfLife.create_gameboard(@width) end, name: :gameboard)
    board_data = Agent.get(:gameboard, & &1) |> GameOfLife.remove_dead_cells()

    {:ok, assign(socket, board: board_data, length: @width + 1, width: 300, height: 150)}
  end

  def handle_event("resize", %{"width" => width, "height" => height}, socket) do
    {:noreply, assign(socket, height: height, width: width)}
  end

  def handle_event("advance", _, socket) do
    Agent.update(:gameboard, &GameOfLife.advance_board(&1))
    next_board_data = Agent.get(:gameboard, & &1) |> GameOfLife.remove_dead_cells()

    {:noreply, assign(socket, board: next_board_data)}
  end
end
