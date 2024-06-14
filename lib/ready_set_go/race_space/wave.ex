defmodule ReadySetGo.RaceSpace.Wave do
  use Ecto.Schema
  import Ecto.Changeset

  schema "waves" do
    field :index, :integer
    field :name, :string
    field :start_time, :naive_datetime_usec
    field :end_time, :naive_datetime_usec
    belongs_to :event, ReadySetGo.RaceSpace.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wave, attrs) do
    wave
    |> cast(attrs, [:name, :index, :event_id, :start_time, :end_time])
    |> validate_required([:name, :event_id, :index])
  end
end
