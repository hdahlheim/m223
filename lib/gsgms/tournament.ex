defmodule GSGMS.Tournament do
  alias __MODULE__.{Management, Players, Teams}

  @moduledoc """
  Tournament Facade
  """

  def check_in_player(player_id),
    do: Management.check_in_player(player_id, DateTime.now!("Europe/Zurich"))

  def check_out_player(player_id),
    do: Management.check_out_player(player_id, DateTime.now!("Europe/Zurich"))

  def subscribe_to(:players), do: Players.subscribe()

  def subscribe_to(:teams), do: Teams.subscribe()

  def subscribe_to(:players, id), do: Players.subscribe(id)

  def subscribe_to(:teams, id), do: Teams.subscribe(id)

  defdelegate add_player_to_team(player_id, team_id), to: Management

  # Player delegation
  defdelegate get_players(), to: Players, as: :list_players
  defdelegate list_players(), to: Players, as: :list_players
  defdelegate get_player!(id), to: Players, as: :get_player_with_associations!
  defdelegate get_players_without_team(), to: Players, as: :list_players_without_team
  defdelegate create_player(player_info), to: Players
  defdelegate delete_player(player), to: Players

  # Teams delegation
  defdelegate get_teams(), to: Teams, as: :list_teams
  defdelegate list_teams(), to: Teams, as: :list_teams
  defdelegate get_team!(id), to: Teams, as: :get_team_with_players!
  defdelegate create_team(team), to: Teams
  defdelegate delete_team(team), to: Teams
end
