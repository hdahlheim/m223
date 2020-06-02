defmodule GSGMS.Games do
  alias __MODULE__.Players

  defdelegate get_players(), to: Players, as: :list_players
  defdelegate get_player_by_id(id), to: Players, as: :get_player!
  defdelegate create_player(player_info), to: Players
end
