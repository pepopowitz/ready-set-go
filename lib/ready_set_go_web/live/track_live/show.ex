defmodule ReadySetGoWeb.TrackLive.Show do
  use ReadySetGoWeb, :live_view
  # alias ReadySetGo.PubSub
  alias ReadySetGo.TrackerSpace
  # alias ReadySetGo.TrackerSpace.Tracker

  @impl true

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: TrackerSpace.subscribe()

    {:ok,
     assign(socket, :event_id, id)
     |> assign(:event, TrackerSpace.get_tracker!(id))
     |> assign(:confirm_rollback, nil)}
  end

  @impl true
  def handle_event("advance_athlete", %{"id" => id}, socket) do
    athlete = TrackerSpace.get_athlete!(id)
    TrackerSpace.advance_athlete(athlete)

    event_id = socket.assigns.event_id

    {:noreply,
     assign(socket, :event, TrackerSpace.get_tracker!(event_id))
     |> assign(:updated_athlete_id, athlete.id)}
  end

  @impl true
  def handle_event("rollback_athlete", %{"id" => id}, socket) do
    id = String.to_integer(id)

    case socket.assigns.confirm_rollback do
      ^id ->
        athlete = TrackerSpace.get_athlete!(id)
        TrackerSpace.rollback_athlete(athlete)

        event_id = socket.assigns.event_id

        {:noreply,
         assign(socket, :event, TrackerSpace.get_tracker!(event_id))
         |> assign(:updated_athlete_id, athlete.id)
         |> assign(:confirm_rollback, nil)}

      nil ->
        Process.send_after(self(), {:reset_confirm, id}, 5000)
        {:noreply, assign(socket, :confirm_rollback, id)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:tracker_updated, athlete}, socket) do
    event_id = socket.assigns.event_id

    {:noreply,
     assign(socket, :event, TrackerSpace.get_tracker!(event_id))
     |> assign(:updated_athlete_id, athlete.id)}
  end

  @impl true
  def handle_info({:reset_confirm, id}, socket) do
    if socket.assigns.confirm_rollback == id do
      {:noreply, assign(socket, :confirm_rollback, nil)}
    else
      {:noreply, socket}
    end
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Tracker")
  #   |> assign(:tracker, TrackerSpace.get_tracker!(id))
  # end

  # # defp apply_action(socket, :new, _params) do
  # #   socket
  # #   |> assign(:page_title, "New Tracker")
  # #   |> assign(:tracker, %Tracker{})
  # # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Trackers")
  #   |> assign(:tracker, nil)
  # end

  # @impl true
  # def handle_info({ReadySetGoWeb.TrackerLive.FormComponent, {:saved, tracker}}, socket) do
  #   {:noreply, stream_insert(socket, :trackers, tracker)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   tracker = TrackerSpace.get_tracker!(id)
  #   {:ok, _} = TrackerSpace.delete_tracker(tracker)

  #   {:noreply, stream_delete(socket, :trackers, tracker)}
  # end
end
