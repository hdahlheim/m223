defmodule GSGMS.Repo.Migrations.CreateCheckIns do
  use Ecto.Migration

  def change do
    create table(:check_ins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:check_ins, [:player])
  end
end
