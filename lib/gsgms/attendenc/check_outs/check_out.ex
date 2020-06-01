defmodule GSGMS.Attendenc.CheckOuts.CheckOut do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Games.Players.Player

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "check_outs" do
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(check_out, attrs) do
    check_out
    # |> cast(attrs, [])
    # |> validate_required([])
    |> put_assoc(:player, attrs.player)
  end
end
