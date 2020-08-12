defmodule GameOfLifeWeb.GameLive do
  use GameOfLifeWeb, :live_view

  @width 200

  def mount(_params, _session, socket) do
    GameOfLife.start_game(@width)

    {:ok,
     assign(socket,
       board: GameOfLife.get_board_data(),
       length: @width + 1,
       width: 300,
       height: 150
     )}
  end

  def handle_event("resize", %{"width" => width, "height" => height}, socket) do
    {:noreply, assign(socket, height: height, width: width)}
  end

  def handle_event("advance", _, socket) do
    GameOfLife.advance()

    {:noreply, assign(socket, board: GameOfLife.get_board_data())}
  end
end
