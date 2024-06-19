defmodule ReadySetGoWeb.WaveController do
  use ReadySetGoWeb, :controller

  alias ReadySetGo.RaceSpace
  alias ReadySetGo.RaceSpace.Wave
  alias ReadySetGo.Repo

  def index(conn, _params) do
    waves = RaceSpace.list_waves([:event])
    render(conn, :index, waves: waves)
  end

  def new(conn, _params) do
    changeset = RaceSpace.change_wave(%Wave{})

    events = get_events()

    render(conn, :new, changeset: changeset, events: events)
  end

  def create(conn, %{"wave" => wave_params}) do
    case RaceSpace.create_wave(wave_params) do
      {:ok, wave} ->
        conn
        |> put_flash(:info, "Wave created successfully.")
        |> redirect(to: ~p"/waves/#{wave}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # is it better to do the Repo.preload here in the controller,
    #  since I know that not every call to get_wave needs it????
    wave = RaceSpace.get_wave!(id) |> Repo.preload(:event)
    render(conn, :show, wave: wave)
  end

  def edit(conn, %{"id" => id}) do
    wave = RaceSpace.get_wave!(id)
    changeset = RaceSpace.change_wave(wave)
    events = get_events()
    render(conn, :edit, wave: wave, changeset: changeset, events: events)
  end

  def update(conn, %{"id" => id, "wave" => wave_params}) do
    wave = RaceSpace.get_wave!(id)

    case RaceSpace.update_wave(wave, wave_params) do
      {:ok, wave} ->
        conn
        |> put_flash(:info, "Wave updated successfully.")
        |> redirect(to: ~p"/waves/#{wave}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, wave: wave, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wave = RaceSpace.get_wave!(id)
    {:ok, _wave} = RaceSpace.delete_wave(wave)

    conn
    |> put_flash(:info, "Wave deleted successfully.")
    |> redirect(to: ~p"/waves")
  end

  defp get_events do
    RaceSpace.list_events()
    |> Enum.map(&{&1.name, &1.id})
  end
end
