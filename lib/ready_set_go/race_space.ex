defmodule ReadySetGo.RaceSpace do
  @moduledoc """
  The RaceSpace context.
  """

  import Ecto.Query, warn: false
  alias ReadySetGo.Repo

  alias ReadySetGo.RaceSpace.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias ReadySetGo.RaceSpace.Athlete

  @doc """
  Returns the list of athletes.

  ## Examples

      iex> list_athletes()
      [%Athlete{}, ...]

  """
  def list_athletes(preload \\ []) do
    Repo.all(Athlete)
    |> Repo.preload(preload)
  end

  @doc """
  Gets a single athlete.

  Raises `Ecto.NoResultsError` if the Athlete does not exist.

  ## Examples

      iex> get_athlete!(123)
      %Athlete{}

      iex> get_athlete!(456)
      ** (Ecto.NoResultsError)

  """
  def get_athlete!(id, preload \\ []) do
    Repo.get!(Athlete, id)
    |> Repo.preload(preload)
  end

  @doc """
  Creates a athlete.

  ## Examples

      iex> create_athlete(%{field: value})
      {:ok, %Athlete{}}

      iex> create_athlete(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_athlete(attrs \\ %{}) do
    %Athlete{}
    |> Athlete.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a athlete.

  ## Examples

      iex> update_athlete(athlete, %{field: new_value})
      {:ok, %Athlete{}}

      iex> update_athlete(athlete, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_athlete(%Athlete{} = athlete, attrs) do
    athlete
    |> Athlete.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a athlete.

  ## Examples

      iex> delete_athlete(athlete)
      {:ok, %Athlete{}}

      iex> delete_athlete(athlete)
      {:error, %Ecto.Changeset{}}

  """
  def delete_athlete(%Athlete{} = athlete) do
    Repo.delete(athlete)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking athlete changes.

  ## Examples

      iex> change_athlete(athlete)
      %Ecto.Changeset{data: %Athlete{}}

  """
  def change_athlete(%Athlete{} = athlete, attrs \\ %{}) do
    Athlete.changeset(athlete, attrs)
  end
end
