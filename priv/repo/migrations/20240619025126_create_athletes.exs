defmodule ReadySetGo.Repo.Migrations.CreateAthletes do
  use Ecto.Migration

  def change do
    create table(:athletes) do
      add :name, :string
      add :number, :integer
      add :wave, :integer
      add :wave_index, :integer
      add :start_time, :naive_datetime_usec
      add :t1_time, :naive_datetime_usec
      add :t2_time, :naive_datetime_usec
      add :end_time, :naive_datetime_usec
      add :event_id, references(:events, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:athletes, [:wave, :wave_index])
  end
end
