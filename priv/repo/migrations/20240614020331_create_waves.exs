defmodule ReadySetGo.Repo.Migrations.CreateWaves do
  use Ecto.Migration

  def change do
    create table(:waves) do
      add :name, :string
      add :index, :integer
      add :start_time, :naive_datetime_usec
      add :end_time, :naive_datetime_usec
      add :event_id, references(:events, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:waves, [:event_id])
  end
end
