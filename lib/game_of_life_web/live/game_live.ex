defmodule GameOfLifeWeb.GameLive do
  use GameOfLifeWeb, :live_view

  @width 200

  def mount(_params, _session, socket) do
    {:ok, pid} = GameOfLife.start_game(@width)

    {:ok,
     assign(socket,
       board: GameOfLife.get_board_data(pid),
       length: @width,
       width: 300,
       height: 150,
       pid: pid
     )}
  end

  def handle_event("resize", %{"width" => width, "height" => height}, socket) do
    {:noreply, assign(socket, height: height, width: width)}
  end

  def handle_event("advance", _, socket) do
    GameOfLife.advance(socket.assigns.pid)

    {:noreply, assign(socket, board: GameOfLife.get_board_data(socket.assigns.pid))}
  end
end
