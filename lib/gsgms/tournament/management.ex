defmodule GSGMS.Tournament.Management do
  alias GSGMS.Repo
  alias GSGMS.Tournament.Players
  alias GSGMS.Tournament.PlayerLogs.PlayerLog
  alias GSGMS.Tournament.Players.Player
  alias GSGMS.Tournament.Teams
  # alias Ecto.Query
  alias Ecto.Multi

  def add_player_to_team(player_id, team_id) when is_binary(player_id) and is_binary(team_id) do
    Multi.new()
    |> Multi.run(:player, fn _, _ -> {:ok, Players.get_player!(player_id)} end)
    |> Multi.run(:team, fn _, _ -> {:ok, Teams.get_team!(team_id)} end)
    |> Multi.update(:add_player_to_team, &player_assoc_team(&1.player, &1.team))
    |> Multi.insert(
      :log,
      &PlayerLog.changeset(%PlayerLog{}, %{
        player: &1.player,
        description: "Player #{&1.player.name} was added to #{&1.team.name}"
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{player: player, team: team}} ->
        Players.broadcast({:ok, player}, :updated)
        Teams.broadcast({:ok, team}, :updated)

      {:error, _failed_op, _value, _other} = result ->
        result
    end
  end

  def check_in_player(id, time) do
    Multi.new()
    |> Multi.run(:player, fn _, _ -> {:ok, Players.get_player_with_logs!(id)} end)
    |> Multi.update(:add_check_in, &Player.changeset(&1.player, %{check_in: time}, :update))
    |> Multi.insert(
      :log,
      &PlayerLog.changeset(%PlayerLog{}, %{
        player: &1.player,
        description: "Player #{&1.player.name} checked in"
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{add_check_in: player}} = changes ->
        Players.broadcast({:ok, player}, :updated)
        changes

      {:error, _failed_op, _value, _other} = result ->
        result
    end
  end

  def check_out_player(id, time) do
    Multi.new()
    |> Multi.run(:player, fn _, _ -> {:ok, Players.get_player_with_logs!(id)} end)
    |> Multi.update(:add_check_out, &Player.changeset(&1.player, %{check_out: time}, :update))
    |> Multi.insert(
      :log,
      &PlayerLog.changeset(%PlayerLog{}, %{
        player: &1.player,
        description: "Player #{&1.player.name} checked out"
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{add_check_out: player}} = changes ->
        Players.broadcast({:ok, player}, :updated)
        changes

      {:error, _action, _value, _other} = result ->
        result
    end
  end

  defp player_assoc_team(player, team) do
    Players.change_player(player)
    |> Ecto.Changeset.put_assoc(:team, team)
  end
end
