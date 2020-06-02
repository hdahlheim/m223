defmodule GSGMS.Games.Players do
  @moduledoc """
  The Games.Players context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GSGMS.Repo

  alias GSGMS.Games.Players.Player
  alias GSGMS.Games.PlayerLogs.PlayerLog

  @topic "players"

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
    multi =
      Multi.new()
      |> Multi.insert(:player, Player.changeset(%Player{}, attrs))
      |> Multi.insert(:log, fn %{player: player} ->
        PlayerLog.changeset(%PlayerLog{}, %{
          player: player,
          description: "Player #{player.id} created"
        })
      end)

    case Repo.transaction(multi) do
      {:ok, changes} ->
        broadcast({:ok, changes.player}, :player_created)

      {:error, changes} ->
        {:error, changes.player}
    end
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
    multi =
      Multi.new()
      |> Multi.update(:player, Player.changeset(player, attrs, :update))
      |> Multi.insert(:log, fn %{player: player_updated} ->
        PlayerLog.changeset(%PlayerLog{}, %{
          player: player_updated,
          description: "Player #{player.id} was updated"
        })
      end)

    case Repo.transaction(multi) do
      {:ok, changes} ->
        player = Repo.preload(changes.player, :logs)
        IO.inspect(player)
        broadcast({:ok, player}, :player_updated)

      {:error, changes} ->
        {:error, changes.player}
    end
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
    Repo.delete(player)
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

  def subscribe() do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, @topic)
  end

  def subscribe(player_id) do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, @topic <> ":#{player_id}")
  end

  defp broadcast({:ok, player}, :player_created = event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic, {event, player})
    {:ok, player}
  end

  defp broadcast({:ok, player}, :player_updated = event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic, {event, player})
    Phoenix.PubSub.broadcast(GSGMS.PubSub, @topic <> ":#{player.id}", {event, player})
    {:ok, player}
  end
end
