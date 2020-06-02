defmodule GSGMS.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :premissions, :map

      timestamps()
    end

    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing, type: :binary_id)
    end

    create index(:users, [:role_id])
  end
end
