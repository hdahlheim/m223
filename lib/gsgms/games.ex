defmodule GSGMS.Games do
  alias __MODULE__.Players

  defdelegate get_players(), to: Players, as: :list_players
  defdelegate get_player_by_id(id), to: Players, as: :get_player!
  defdelegate create_player(player_info), to: Players

  def check_in_player(player_id) do
    Players.check_in_player(player_id, DateTime.now!("Europe/Zurich"))
  end

  def check_out_player(player_id) do
    Players.check_out_player(player_id, DateTime.now!("Europe/Zurich"))
  end

  def subscribe_to(:players) do
    Players.subscribe()
  end

  def subscribe_to(:players, with: id) do
    Players.subscribe(id)
  end
end
