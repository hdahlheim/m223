defmodule GSGMS.Games.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Games.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "teams" do
    field :name, :string
    has_many :players, Player
    # field :matches, :binary_id
    field :version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def changeset(:update, team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> optimistic_lock(:version)
  end
end
