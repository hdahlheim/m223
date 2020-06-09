defmodule GSGMS.Tournament.Teams do
  @moduledoc """
  The Games.Teams context.
  """

  import Ecto.Query, warn: false
  alias GSGMS.Repo

  alias GSGMS.Tournament.Teams.Team

  def topic, do: "teams"
  def topic(id), do: "teams:#{id}"

  def subscribe() do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, topic())
  end

  def subscribe(team_id) do
    Phoenix.PubSub.subscribe(GSGMS.PubSub, topic(team_id))
  end

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id) |> Repo.preload(:players)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:team_created)
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
    |> broadcast(:team_updated)
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def broadcast({:error, _team} = result, _), do: result

  def broadcast({:ok, team}, :updated = event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(), {:team_event, event, team})
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(team.id), {:team_event, event, team})
    {:ok, team}
  end

  def broadcast({:ok, team}, event) do
    Phoenix.PubSub.broadcast(GSGMS.PubSub, topic(), {:team_event, event, team})
    {:ok, team}
  end
end
