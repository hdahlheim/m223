defmodule GSGMS.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :version, :integer

      timestamps()
    end

    alter table(:players) do
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
    end

    create index(:players, [:team_id])
  end
end
