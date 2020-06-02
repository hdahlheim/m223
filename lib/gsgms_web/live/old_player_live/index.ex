defmodule GSGMSWeb.OldPlayerLive.Index do
  use GSGMSWeb, :live_view

  alias GSGMS.Games

  @impl true
  def mount(_session, _params, socket) do
    players = Games.get_players()

    {:ok, assign(socket, :players, players)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <button phx-click="add-user">
        Add
      </button>
      <div>
        <%= for player <- @players do %>
        <div>
          <%= player.name %>
          <%= player.code %>
        </div>
        <% end %>
      </div>
    """
  end

  @impl true
  def handle_event("add-user", _, socket) do
    {:ok, player} = Games.create_player(%{name: "test", code: "1232131231231"})

    socket =
      socket
      |> update(:players, fn players -> [player | players] end)
      |> put_flash(:info, "Player added")

    {:noreply, socket}
  end
end
