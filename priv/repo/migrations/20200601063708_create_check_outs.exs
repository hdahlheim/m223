defmodule GSGMS.Repo.Migrations.CreateCheckOuts do
  use Ecto.Migration

  def change do
    create table(:check_outs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:check_outs, [:player])
  end
end
