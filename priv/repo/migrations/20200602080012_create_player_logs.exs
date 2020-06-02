defmodule GSGMS.Repo.Migrations.CreatePlayerLogs do
  use Ecto.Migration

  def change do
    create table(:player_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :player_id, references(:players, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:player_logs, [:player_id])
  end
end
