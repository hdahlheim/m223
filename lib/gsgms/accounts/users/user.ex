defmodule GSGMS.Accounts.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Accounts.Roles.Role
  alias GSGMS.Accounts.UserLogs.UserLog

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :version, :integer, default: 1
    belongs_to :role, Role
    has_many :logs, UserLog

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :version])
    |> validate_required([:name, :email, :password, :version])
  end
end
