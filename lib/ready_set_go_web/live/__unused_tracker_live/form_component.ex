# I think this is unused, but nice to keep around for reference?

defmodule ReadySetGoWeb.TrackerLive.FormComponent do
  use ReadySetGoWeb, :live_component

  alias ReadySetGo.TrackerSpace

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tracker records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tracker-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:start_time]} type="text" label="Start time" />
        <.input field={@form[:end_time]} type="text" label="End time" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tracker</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tracker: tracker} = assigns, socket) do
    changeset = TrackerSpace.change_tracker(tracker)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tracker" => tracker_params}, socket) do
    changeset =
      socket.assigns.tracker
      |> TrackerSpace.change_tracker(tracker_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tracker" => tracker_params}, socket) do
    save_tracker(socket, socket.assigns.action, tracker_params)
  end

  defp save_tracker(socket, :edit, tracker_params) do
    case TrackerSpace.update_tracker(socket.assigns.tracker, tracker_params) do
      {:ok, tracker} ->
        notify_parent({:saved, tracker})

        {:noreply,
         socket
         |> put_flash(:info, "Tracker updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tracker(socket, :new, tracker_params) do
    case TrackerSpace.create_tracker(tracker_params) do
      {:ok, tracker} ->
        notify_parent({:saved, tracker})

        {:noreply,
         socket
         |> put_flash(:info, "Tracker created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
