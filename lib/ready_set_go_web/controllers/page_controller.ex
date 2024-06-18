defmodule ReadySetGoWeb.PageController do
  use ReadySetGoWeb, :controller
  alias ReadySetGo.TrackerSpace

  def home(conn, _params) do
    camundathlon = TrackerSpace.get_camundathlon?()

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, camundathlon: camundathlon)
  end
end
