defmodule GSGMS.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      # add :players, references(:players, on_delete: :nothing, type: :binary_id)
      # add :matches, references(:team_matches, on_delete: :nothing, type: :binary_id)
      add :version, :integer

      timestamps()
    end

    # create index(:teams, [:players])
    # create index(:teams, [:matches])
  end
end
