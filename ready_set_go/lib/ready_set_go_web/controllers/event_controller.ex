defmodule ReadySetGoWeb.EventController do
  use ReadySetGoWeb, :controller

  alias ReadySetGo.RaceSpace
  alias ReadySetGo.RaceSpace.Event

  def index(conn, _params) do
    events = RaceSpace.list_events()
    render(conn, :index, events: events)
  end

  def new(conn, _params) do
    changeset = RaceSpace.change_event(%Event{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case RaceSpace.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = RaceSpace.get_event!(id)
    render(conn, :show, event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = RaceSpace.get_event!(id)
    changeset = RaceSpace.change_event(event)
    render(conn, :edit, event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = RaceSpace.get_event!(id)

    case RaceSpace.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = RaceSpace.get_event!(id)
    {:ok, _event} = RaceSpace.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: ~p"/events")
  end
end
