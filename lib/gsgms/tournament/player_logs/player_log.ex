defmodule GSGMS.Tournament.PlayerLogs.PlayerLog do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Tournament.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "player_logs" do
    field :description, :string
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(player_log, %{player: player} = attrs) do
    player_log
    |> cast(attrs, [:description])
    |> validate_required([:description])
    |> put_assoc(:player, player)
  end

  @doc false
  def changeset(player_log, attrs) do
    player_log
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
