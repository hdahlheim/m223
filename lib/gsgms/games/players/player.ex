defmodule GSGMS.Games.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Games.Teams.Team
  alias GSGMS.Games.PlayerLogs.PlayerLog

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "players" do
    field :code, :string
    field :name, :string
    field :check_in, :utc_datetime_usec
    field :check_out, :utc_datetime_usec
    belongs_to :team, Team
    has_many :logs, PlayerLog
    field :version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end

  @doc false
  def changeset(player, attrs, :update) do
    player
    |> cast(attrs, [:name, :code, :check_in, :check_out])
    |> validate_required([:name, :code])
    |> optimistic_lock(:version)
  end
end
