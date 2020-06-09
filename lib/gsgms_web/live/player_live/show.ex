defmodule GSGMSWeb.PlayerLive.Show do
  use GSGMSWeb, :live_view

  alias GSGMS.Tournament

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Tournament.subscribe_to(:players, id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:player, Tournament.get_player!(id))}
  end

  @impl true
  def handle_info({:player_event, :updated, player}, socket) do
    socket =
      socket
      |> assign(:player, Tournament.get_player!(player.id))
      |> put_flash(:info, "Player was updated")

    {:noreply, socket}
  end

  @impl true
  def handle_event("check-in", %{"value" => player_id}, socket) do
    Tournament.check_in_player(player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("check-out", %{"value" => player_id}, socket) do
    Tournament.check_out_player(player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-team", %{"team-id" => team_id}, socket) do
    player_id = socket.assigns.player.id
    Tournament.add_player_to_team(player_id, team_id)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Player"
  defp page_title(:edit), do: "Edit Player"

  def is_checked_in?(player) do
    !is_nil(player.check_in)
  end

  def is_checked_out?(player) do
    !is_nil(player.check_out)
  end

  defp team_options do
    Tournament.get_teams()
    |> Enum.map(fn team -> {team.name, team.id} end)
  end
end
