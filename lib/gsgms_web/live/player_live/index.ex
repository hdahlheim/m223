defmodule GSGMSWeb.PlayerLive.Index do
  use GSGMSWeb, :live_view

  alias GSGMS.Tournament
  alias GSGMS.Tournament.Players
  alias GSGMS.Tournament.Players.Player

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Tournament.subscribe_to(:players)

    socket =
      socket
      |> assign_defaults(session)
      |> assign(players: list_players())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = check_privilege(socket, Players)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:player_event, :created, _player}, socket) do
    {:noreply, assign(socket, players: list_players())}
  end

  @impl true
  def handle_info({:player_event, :updated, _player}, socket) do
    {:noreply, assign(socket, players: list_players())}
  end

  @impl true
  def handle_info({:player_event, :deleted, _}, socket) do
    {:noreply, assign(socket, players: list_players())}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    with {:ok, socket} <- has_privilege(socket, :delete, Players) do
      player = Tournament.get_player!(id)
      {:ok, _} = Tournament.delete_player(player)

      socket =
        assign(socket, players: list_players())
        |> put_flash(:info, "Player #{player.name} deleted")

      {:noreply, socket}
    else
      {_, socket} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("check-in", %{"value" => player_id}, socket) do
    with {:ok, socket} <- has_privilege(socket, :update, Players) do
      Tournament.check_in_player(player_id)
      {:noreply, socket}
    else
      {_, socket} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("check-out", %{"value" => player_id}, socket) do
    with {:ok, socket} <- has_privilege(socket, :update, Players) do
      Tournament.check_out_player(player_id)
      {:noreply, socket}
    else
      {_, socket} ->
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Tournament.get_player!(id))
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

  defp list_players do
    Tournament.list_players()
  end
end
