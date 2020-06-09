defmodule GSGMSWeb.TeamLive.Show do
  use GSGMSWeb, :live_view

  alias GSGMS.Tournament

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :players, Tournament.get_players_without_team())
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Tournament.subscribe_to(:teams, id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:team, Tournament.get_team!(id))}
  end

  @impl true
  def handle_info({:team_event, :updated, team}, socket) do
    {:noreply,
     assign(socket,
       team: Tournament.get_team!(team.id),
       players: Tournament.get_players_without_team()
     )}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-player", %{"player-id" => player_id}, socket) do
    unless byte_size(player_id) == 0 do
      team_id = socket.assigns.team.id
      Tournament.add_player_to_team(player_id, team_id)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"

  defp player_options(players) do
    players
    |> Enum.map(fn player -> {player.name, player.id} end)
  end
end
