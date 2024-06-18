# I think this is unused, but nice to keep around for reference?

defmodule ReadySetGoWeb.TrackerLive.Index do
  use ReadySetGoWeb, :live_view

  alias ReadySetGo.TrackerSpace
  alias ReadySetGo.TrackerSpace.Tracker

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :trackers, TrackerSpace.list_trackers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tracker")
    |> assign(:tracker, TrackerSpace.get_tracker!(id))
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Tracker")
  #   |> assign(:tracker, %Tracker{})
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trackers")
    |> assign(:tracker, nil)
  end

  @impl true
  def handle_info({ReadySetGoWeb.TrackerLive.FormComponent, {:saved, tracker}}, socket) do
    {:noreply, stream_insert(socket, :trackers, tracker)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tracker = TrackerSpace.get_tracker!(id)
    {:ok, _} = TrackerSpace.delete_tracker(tracker)

    {:noreply, stream_delete(socket, :trackers, tracker)}
  end
end
