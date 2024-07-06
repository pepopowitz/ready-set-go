defmodule ReadySetGo.RaceSpace.Athlete do
  use Ecto.Schema
  import Ecto.Changeset

  schema "athletes" do
    field :name, :string
    field :number, :integer
    field :wave, :integer
    field :wave_index, :integer
    field :start_time, :naive_datetime_usec
    field :t1_time, :naive_datetime_usec
    field :t2_time, :naive_datetime_usec
    field :end_time, :naive_datetime_usec
    belongs_to :event, ReadySetGo.RaceSpace.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(athlete, attrs) do
    athlete
    |> cast(attrs, [
      :name,
      :event_id,
      :number,
      :wave,
      :wave_index,
      :start_time,
      :t1_time,
      :t2_time,
      :end_time
    ])
    |> validate_required([:name, :event_id, :number, :wave, :wave_index])
  end
end
