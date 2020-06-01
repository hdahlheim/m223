defmodule GSGMS.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :password, :string
      add :version, :integer
      add :role, references(:roles, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:users, [:role])
  end
end
