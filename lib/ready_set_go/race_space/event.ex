defmodule ReadySetGo.RaceSpace.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:name, :string)
    field(:start_time, :naive_datetime_usec)
    field(:end_time, :naive_datetime_usec)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :start_time, :end_time])
    |> validate_required([:name])
  end
end
