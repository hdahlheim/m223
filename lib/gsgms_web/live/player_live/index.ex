defmodule GSGMSWeb.PlayerLive.Index do
  use GSGMSWeb, :live_view

  alias GSGMS.Games
  alias GSGMS.Games.Players
  alias GSGMS.Games.Players.Player

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Players.subscribe()
    {:ok, assign(socket, players: list_players(), temporary_assigns: [:players])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:player_created, player}, socket) do
    {:noreply, assign(socket, :players, [player])}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Players.get_player!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, %Player{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    player = Players.get_player!(id)
    {:ok, _} = Players.delete_player(player)

    {:noreply, assign(socket, :players, list_players())}
  end

  @impl true
  def handle_event("check-in", %{"value" => player_id}, socket) do
    IO.inspect(player_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("check-out", %{"value" => player_id}, socket) do
    IO.inspect(player_id)
    {:noreply, socket}
  end

  defp list_players do
    Games.get_players()
  end
end
