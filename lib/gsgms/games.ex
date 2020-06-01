defmodule GSGMS.Games do
  alias __MODULE__.Players

  defdelegate get_player_by_id(id), to: Players, as: :get_player!
end
