defmodule GSGMS.Repo.Migrations.CreateUserLogs do
  use Ecto.Migration

  def change do
    create table(:user_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :user, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:user_logs, [:user])
  end
end
