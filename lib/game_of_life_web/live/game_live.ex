defmodule GameOfLifeWeb.GameLive do
  use Phoenix.LiveView

  @width 200

  def render(assigns) do
    ~L"""
    <div class="flex">
      <canvas
        width="<%= @width %>"
        height="<%= @height %>"
        data-board="<%= Jason.encode!(@board) %>"
        data-length="<%= @length %>"
        phx-hook="canvas"
      ></canvas>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    GameOfLife.Server.start_link(@width)
    board_data = GameOfLife.Server.get() |> GameOfLife.to_list()

    {:ok, assign(socket, board: board_data, length: @width + 1, width: 300, height: 150)}
  end

  def handle_event("resize", %{"width" => width, "height" => height}, socket) do
    {:noreply, assign(socket, height: height, width: width)}
  end

  def handle_event("advance", _, socket) do
    next_board_data = GameOfLife.Server.advance() |> GameOfLife.to_list()

    {:noreply, assign(socket, board: next_board_data)}
  end
end
