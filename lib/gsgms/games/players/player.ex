defmodule GSGMS.Games.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Games.Teams.Team
  alias GSGMS.Attendenc.CheckIns.CheckIn
  alias GSGMS.Attendenc.CheckOuts.CheckOut

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :code, :string
    field :name, :string
    belongs_to :team, Team
    has_one :check_in, CheckIn
    has_one :check_out, CheckOut
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
  def changeset(:update, player, attrs) do
    player
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
    |> optimistic_lock(:version)
  end
end
