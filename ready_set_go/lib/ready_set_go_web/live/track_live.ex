defmodule ReadySetGoWeb.TrackLive do
  use ReadySetGoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ReadySetGoWeb.TrackView.render("track.html", assigns)
  end
end
