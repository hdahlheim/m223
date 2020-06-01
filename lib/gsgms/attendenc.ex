defmodule GSGMS.Attendenc do
  alias __MODULE__.CheckIns
  alias __MODULE__.CheckOuts
  alias GSGMS.Games

  def check_in_player(id) do
    player = Games.get_player_by_id(id)

    CheckIns.create_check_in(%{player: player})
  end

  def check_out_player(id) do
    player = Games.get_player_by_id(id)

    CheckOuts.create_check_out(%{player: player})
  end
end
