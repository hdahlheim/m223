defmodule GSGMS.Accounts.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Accounts.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "roles" do
    field :name, :string
    field :premissions, :map
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :premissions])
    |> validate_required([:name, :premissions])
  end
end
