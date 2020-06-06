defmodule GSGMS.Tournament.Players do
  @moduledoc """
  The Games.Players context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GSGMS.Repo

  alias GSGMS.Tournament.Players.Player
  alias GSGMS.Tournament.PlayerLogs.PlayerLog

  @topic "players"

  @doc """
  Subscribe to creation, update and deletion events
  that happen on the player table.
  """
  def subscribe() do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, @topic)
  end

  @doc """
  Subscribe to creation, update and deletion events
  of a paticular player id.
  """
  def subscribe(player_id) do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, @topic <> ":#{player_id}")
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

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id) |> Repo.preload(:logs)

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
    |> add_player_log("created")
    |> run_and_broadcast(:player_created)
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
    |> Multi.update(:player, Player.changeset(player, attrs, :update))
    |> add_player_log("info was updated")
    |> run_and_broadcast(:player_updated)
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
        broadcast({:ok, player}, :player_deleted)

      {:error, player} ->
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

  def check_in_player(id, time) do
    Multi.new()
    |> Multi.run(:get_player, fn _, _ ->
      {:ok, Repo.get!(Player, id)}
    end)
    |> Multi.update(:player, fn %{get_player: player} ->
      Player.changeset(player, %{check_in: time}, :update)
    end)
    |> add_player_log("checked in at #{time}")
    |> run_and_broadcast(:player_updated)
  end

  def check_out_player(id, time) do
    Multi.new()
    |> Multi.run(:get_player, fn _, _ ->
      {:ok, Repo.get!(Player, id)}
    end)
    |> Multi.update(:player, fn %{get_player: player} ->
      Player.changeset(player, %{check_out: time}, :update)
    end)
    |> add_player_log("checked out at #{time}")
    |> run_and_broadcast(:player_updated)
  end

  defp add_player_log(%Multi{} = multi, msg) do
    Multi.insert(multi, :log, fn %{player: player} ->
      PlayerLog.changeset(%PlayerLog{}, %{
        player: player,
        description: "Player #{player.name} " <> msg
      })
    end)
  end

  defp run_and_broadcast(%Multi{} = multi, broadcastEvent) do
    case Repo.transaction(multi) do
      {:ok, changes} ->
        broadcast({:ok, changes.player}, broadcastEvent)

      {:error, changes} ->
        {:error, changes.player}
    end
  end

  defp broadcast({:ok, player}, :player_updated = event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic, {event, player})
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic <> ":#{player.id}", {event, player})
    {:ok, player}
  end

  defp broadcast({:ok, player}, event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic, {event, player})
    {:ok, player}
  end
end
