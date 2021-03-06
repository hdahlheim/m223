defmodule GSGMS.Tournament.Players do
  @moduledoc """
  The Tournament.Players context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GSGMS.Repo

  alias GSGMS.Tournament.Players.Player
  alias GSGMS.Tournament.PlayerLogs.PlayerLog

  @update_opts stale_error_field: :version, stale_error_message: "User information is stale"

  def topic, do: "players"
  def topic(id), do: "players:#{id}"

  @doc """
  Subscribe to creation, update and deletion events
  that happen on the player table.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, topic())
  end

  @doc """
  Subscribe to creation, update and deletion events
  of a paticular player id.
  """
  def subscribe(player_id) do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, topic(player_id))
  end

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  def list_players_without_team do
    players_where_team_is_nill()
    |> Repo.all()
  end

  defp players_where_team_is_nill do
    from p in Player,
      where: is_nil(p.team_id),
      select: %{name: p.name, id: p.id}
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  def get_player_with_logs!(id),
    do: Repo.get!(Player, id) |> Repo.preload(:logs)

  def get_player_with_team!(id),
    do: Repo.get!(Player, id) |> Repo.preload(:team)

  def get_player_with_associations!(id),
    do: Repo.get!(Player, id) |> Repo.preload([:team, :logs])

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:player, Player.changeset(%Player{}, attrs))
    |> Multi.insert(
      :log,
      &PlayerLog.changeset(%PlayerLog{}, %{
        player: &1.player,
        description: "Player #{&1.player.name} was created"
      })
    )
    |> Repo.transaction()
    |> process_result(:created)
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    Multi.new()
    |> Multi.update(:player, Player.changeset(player, attrs, :update), @update_opts)
    |> Multi.insert(
      :log,
      &PlayerLog.changeset(%PlayerLog{}, %{
        player: &1.player,
        description: "Player #{&1.player.name} info was updated"
      })
    )
    |> Repo.transaction()
    |> process_result(:updated)
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    case Repo.transaction(fn -> Repo.delete!(player) end) do
      {:ok, player} ->
        broadcast({:ok, player}, :deleted)

      {:error, :player, player, _} ->
        {:error, player}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs, :update)
  end

  defp process_result(result, broadcastEvent) do
    case result do
      {:ok, %{player: player}} ->
        broadcast({:ok, player}, broadcastEvent)

      {:error, :player, player, _} ->
        {:error, player}
    end
  end

  def broadcast({:ok, player}, :updated = event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(), {:player_event, event, player})
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(player.id), {:player_event, event, player})
    {:ok, player}
  end

  def broadcast({:ok, player}, event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(), {:player_event, event, player})
    {:ok, player}
  end

  def broadcast({:error, _player} = result, _event), do: result
end
