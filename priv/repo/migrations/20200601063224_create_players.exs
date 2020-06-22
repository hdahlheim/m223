defmodule GSGMS.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :check_in, :utc_datetime_usec
      add :check_out, :utc_datetime_usec
      add :version, :integer

      timestamps()
    end
  end
end
