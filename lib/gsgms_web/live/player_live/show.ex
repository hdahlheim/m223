defmodule GSGMSWeb.PlayerLive.Show do
  use GSGMSWeb, :live_view

  alias GSGMS.Games.Players

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_info({:player_updated, player}, socket) do
    {:noreply,
     socket
     |> assign(:player, player)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Players.subscribe(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:player, Players.get_player!(id))}
  end

  @impl true
  def handle_event("check-in", %{"value" => player_id}, socket) do
    # save_user(socket, socket.assigns.action, user_params)
    IO.inspect(player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("check-out", %{"value" => player_id}, socket) do
    # save_user(socket, socket.assigns.action, user_params)
    IO.inspect(player_id)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Player"
  defp page_title(:edit), do: "Edit Player"

  def is_checked_in?(player) do
    if is_nil(player.check_in) do
      false
    else
      true
    end
  end

  def is_checked_out?(player) do
    if is_nil(player.check_out) do
      false
    else
      true
    end
  end
end
