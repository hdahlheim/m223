defmodule GSGMS.Attendenc.CheckIns.CheckIn do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Games.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "check_ins" do
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(check_in, attrs) do
    check_in
    # |> cast(attrs, [])
    # |> validate_required([])
    |> put_assoc(:player, attrs.player)
  end
end
