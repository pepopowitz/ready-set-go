defmodule ReadySetGo.Repo do
  use Ecto.Repo,
    otp_app: :ready_set_go,
    adapter: Ecto.Adapters.Postgres
end
