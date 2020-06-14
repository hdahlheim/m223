defmodule GSGMSWeb.TeamLive.Index do
  use GSGMSWeb, :live_view

  alias GSGMS.Tournament
  alias GSGMS.Tournament.Teams
  alias GSGMS.Tournament.Teams.Team

  @impl true
  def mount(_params, _session, socket) do
    Tournament.subscribe_to(:teams)
    {:ok, assign(socket, :teams, list_teams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:team_event, :created, _team}, socket) do
    {:noreply, assign(socket, :teams, list_teams())}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Tournament.get_team!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Tournament.get_team!(id)
    {:ok, _} = Teams.delete_team(team)

    {:noreply, assign(socket, :teams, list_teams())}
  end

  defp list_teams do
    Tournament.get_teams()
  end
end
