defmodule GSGMS.Tournament.PlayerLogs do
  @moduledoc """
  The Games.PlayerLogs context.
  """

  import Ecto.Query, warn: false
  alias GSGMS.Repo

  alias GSGMS.Tournament.PlayerLogs.PlayerLog

  @doc """
  Returns the list of player_logs.

  ## Examples

      iex> list_player_logs()
      [%PlayerLog{}, ...]

  """
  def list_player_logs do
    Repo.all(PlayerLog)
    |> Repo.preload(:player)
  end

  @doc """
  Gets a single player_log.

  Raises `Ecto.NoResultsError` if the Player log does not exist.

  ## Examples

      iex> get_player_log!(123)
      %PlayerLog{}

      iex> get_player_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_log!(id), do: Repo.get!(PlayerLog, id) |> Repo.preload(:player)

  @doc """
  Creates a player_log.

  ## Examples

      iex> create_player_log(%{field: value})
      {:ok, %PlayerLog{}}

      iex> create_player_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_log(attrs \\ %{}) do
    %PlayerLog{}
    |> PlayerLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a player_log.

  ## Examples

      iex> delete_player_log(player_log)
      {:ok, %PlayerLog{}}

      iex> delete_player_log(player_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_log(%PlayerLog{} = player_log) do
    Repo.delete(player_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_log changes.

  ## Examples

      iex> change_player_log(player_log)
      %Ecto.Changeset{data: %PlayerLog{}}

  """
  def change_player_log(%PlayerLog{} = player_log, attrs \\ %{}) do
    PlayerLog.changeset(player_log, attrs)
  end
end
