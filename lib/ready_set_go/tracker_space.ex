defmodule ReadySetGo.TrackerSpace do
  @moduledoc """
  The TrackerSpace context.
  """

  import Ecto.Query, warn: false
  alias ReadySetGo.Repo

  alias ReadySetGo.RaceSpace.Event
  alias ReadySetGo.RaceSpace.Wave
  alias ReadySetGo.RaceSpace.Athlete

  # pubsub stuff so other liveviews can see the updates
  alias Phoenix.PubSub

  def subscribe() do
    PubSub.subscribe(ReadySetGo.PubSub, "ready_set_go")
  end

  def notify({:ok, tracker}, event) do
    PubSub.broadcast(ReadySetGo.PubSub, "ready_set_go", {event, tracker})
  end

  def notify({:error, reason}, _event), do: {:error, reason}
  ## end pubsub stuff

  @doc """
  Returns the list of trackers.

  ## Examples

      iex> list_trackers()
      [%Tracker{}, ...]

  """
  def list_trackers do
    Repo.all(Event)
  end

  @doc """
  Gets a single tracker.

  Raises `Ecto.NoResultsError` if the Tracker does not exist.

  ## Examples

      iex> get_tracker!(123)
      %Tracker{}

      iex> get_tracker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tracker!(id) do
    query =
      from(e in Event,
        where: e.id == ^id,
        join: w in assoc(e, :waves),
        join: a in assoc(w, :athletes),
        order_by: [asc: w.index, asc: a.wave_index],
        preload: [waves: {w, athletes: a}]
      )

    Repo.one!(query)
  end

  # I don't know, should I be doing this here or creating its own space?
  #  I don't really know how to use spaces.
  def get_camundathlon?() do
    Repo.get_by(Event, name: "Camundathlon")
  end

  @doc """
  Creates a tracker.

  ## Examples

      iex> create_tracker(%{field: value})
      {:ok, %Tracker{}}

      iex> create_tracker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tracker(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tracker.

  ## Examples

      iex> update_tracker(tracker, %{field: new_value})
      {:ok, %Tracker{}}

      iex> update_tracker(tracker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tracker(%Event{} = tracker, attrs) do
    tracker
    |> Event.changeset(attrs)
    |> Repo.update()
    |> notify(:tracker_updated)
  end

  @doc """
  Deletes a tracker.

  ## Examples

      iex> delete_tracker(tracker)
      {:ok, %Tracker{}}

      iex> delete_tracker(tracker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tracker(%Event{} = tracker) do
    Repo.delete(tracker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tracker changes.

  ## Examples

      iex> change_tracker(tracker)
      %Ecto.Changeset{data: %Tracker{}}

  """
  def change_tracker(%Event{} = tracker, attrs \\ %{}) do
    Event.changeset(tracker, attrs)
  end

  def get_wave!(id) do
    Repo.get!(Wave, id)
  end

  @doc """
  Updates a wave.

  ## Examples

      iex> update_wave(wave, %{field: new_value})
      {:ok, %Wave{}}

      iex> update_wave(wave, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wave(%Wave{} = wave, attrs) do
    wave
    |> Wave.changeset(attrs)
    |> Repo.update()
    |> notify(:tracker_updated)
  end

  def maybe_start_wave?(wave_id, now) do
    wave = get_wave!(wave_id)

    if wave.start_time == nil do
      wave
      |> Wave.changeset(%{start_time: now})
      |> Repo.update()
    end
  end

  def maybe_rollback_wave?(wave_id) do
    query = from(a in Athlete, where: a.wave_id == ^wave_id, where: not is_nil(a.start_time))

    any_started_athlete = Repo.one(query)

    if any_started_athlete == nil do
      wave = get_wave!(wave_id)

      wave
      |> Wave.changeset(%{start_time: nil})
      |> Repo.update()
    end
  end

  def get_athlete!(id) do
    Repo.get!(Athlete, id)
  end

  def advance_athlete(%Athlete{} = athlete) do
    now = DateTime.utc_now()

    changes =
      cond do
        athlete.start_time == nil -> %{start_time: now}
        athlete.t1_time == nil -> %{t1_time: now}
        athlete.t2_time == nil -> %{t2_time: now}
        athlete.end_time == nil -> %{end_time: now}
        true -> nil
      end

    if changes != nil do
      updated_athlete =
        athlete
        |> Athlete.changeset(changes)
        |> Repo.update()

      maybe_start_wave?(athlete.wave_id, now)

      notify(updated_athlete, :tracker_updated)
    end
  end

  def rollback_athlete(%Athlete{} = athlete) do
    changes =
      cond do
        athlete.end_time != nil -> %{end_time: nil}
        athlete.t2_time != nil -> %{t2_time: nil}
        athlete.t1_time != nil -> %{t1_time: nil}
        athlete.start_time != nil -> %{start_time: nil}
        true -> nil
      end

    if changes != nil do
      updated_athlete =
        athlete
        |> Athlete.changeset(changes)
        |> Repo.update()

      maybe_rollback_wave?(athlete.wave_id)

      notify(updated_athlete, :tracker_updated)
    end
  end
end
