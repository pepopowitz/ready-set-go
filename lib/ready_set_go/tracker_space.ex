defmodule ReadySetGo.TrackerSpace do
  @moduledoc """
  The TrackerSpace context.
  """

  import Ecto.Query, warn: false
  alias ReadySetGo.Repo

  alias ReadySetGo.RaceSpace.Event
  alias ReadySetGo.RaceSpace.Wave

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
    Repo.get!(Event, id) |> Repo.preload(:waves)
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
end
