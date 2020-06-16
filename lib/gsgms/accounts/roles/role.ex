defmodule GSGMS.Accounts.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Accounts.Users.User

  schema "roles" do
    field :name, :string
    field :create, :map
    field :read, :map
    field :update, :map
    field :delete, :map
    has_many :users, User
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :create, :read, :update, :delete])
    |> validate_required([:name])
  end
end
