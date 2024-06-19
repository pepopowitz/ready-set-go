defmodule ReadySetGo.RaceSpace.Athlete do
  use Ecto.Schema
  import Ecto.Changeset

  schema "athletes" do
    field :name, :string
    field :number, :integer
    field :wave_index, :integer
    field :start_time, :naive_datetime_usec
    field :t1_time, :naive_datetime_usec
    field :t2_time, :naive_datetime_usec
    field :end_time, :naive_datetime_usec
    belongs_to :wave, ReadySetGo.RaceSpace.Wave

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(athlete, attrs) do
    athlete
    |> cast(attrs, [
      :name,
      :number,
      :wave_id,
      :wave_index,
      :start_time,
      :t1_time,
      :t2_time,
      :end_time
    ])
    |> validate_required([:name, :number, :wave_id, :wave_index])
  end
end
