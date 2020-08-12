defmodule GameOfLifeWeb.GameLive do
  use GameOfLifeWeb, :live_view

  @width 200

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :start_game, 100)

    {:ok,
     socket
     |> assign_new(:board, fn -> [] end)
     |> assign(length: @width, width: 300, height: 150)}
  end

  def handle_event("resize", %{"width" => width, "height" => height}, socket) do
    {:noreply, assign(socket, height: height, width: width)}
  end

  def handle_event("advance", _, socket) do
    if socket.assigns[:pid] do
      GameOfLife.advance(socket.assigns.pid)

      {:noreply, assign(socket, board: GameOfLife.get_board_data(socket.assigns.pid))}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:start_game, socket) do
    {:ok, pid} = GameOfLife.start_game(@width)

    {:noreply, assign(socket, board: GameOfLife.get_board_data(pid), pid: pid)}
  end
end
