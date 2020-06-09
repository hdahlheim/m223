defmodule GSGMS.Tournament do
  alias __MODULE__.Players
  alias __MODULE__.Teams
  alias __MODULE__.Management

  def get_players_without_team do
    Players.list_players(:without_team)
  end

  def check_in_player(player_id) do
    Management.check_in_player(player_id, DateTime.now!("Europe/Zurich"))
  end

  def check_out_player(player_id) do
    Management.check_out_player(player_id, DateTime.now!("Europe/Zurich"))
  end

  def subscribe_to(:players) do
    Players.subscribe()
  end

  def subscribe_to(:teams) do
    Teams.subscribe()
  end

  def subscribe_to(:players, id) do
    Players.subscribe(id)
  end

  def subscribe_to(:teams, id) do
    Teams.subscribe(id)
  end

  defdelegate get_players(), to: Players, as: :list_players
  defdelegate get_player!(id), to: Players
  defdelegate create_player(player_info), to: Players
  defdelegate get_teams(), to: Teams, as: :list_teams
  defdelegate get_team!(id), to: Teams
  defdelegate create_team(player_info), to: Teams
  defdelegate add_player_to_team(player_id, team_id), to: Management
end
