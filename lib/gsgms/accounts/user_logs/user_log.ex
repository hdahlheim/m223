defmodule GSGMS.Accounts.UserLogs.UserLog do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSGMS.Accounts.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_logs" do
    field :description, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_log, attrs) do
    user_log
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
