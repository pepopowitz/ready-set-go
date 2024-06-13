defmodule ReadySetGo.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :start_time, :naive_datetime_usec
      add :end_time, :naive_datetime_usec

      timestamps(type: :utc_datetime)
    end
  end
end
