defmodule GSGMS.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :team, references(:teams, on_delete: :nothing, type: :binary_id)
      add :check_in, references(:check_ins, on_delete: :nothing, type: :binary_id)
      add :check_out, references(:check_outs, on_delete: :nothing, type: :binary_id)
      add :version, :integer

      timestamps()
    end

    create index(:players, [:team])
    create index(:players, [:check_in])
    create index(:players, [:check_out])
  end
end