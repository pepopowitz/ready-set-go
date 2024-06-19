defmodule ReadySetGoWeb.AthleteController do
  use ReadySetGoWeb, :controller

  alias ReadySetGo.RaceSpace
  alias ReadySetGo.RaceSpace.Athlete

  def index(conn, _params) do
    athletes = RaceSpace.list_athletes([:wave])
    render(conn, :index, athletes: athletes)
  end

  def new(conn, _params) do
    changeset = RaceSpace.change_athlete(%Athlete{})

    waves = get_waves()

    render(conn, :new, changeset: changeset, waves: waves)
  end

  def create(conn, %{"athlete" => athlete_params}) do
    case RaceSpace.create_athlete(athlete_params) do
      {:ok, athlete} ->
        conn
        |> put_flash(:info, "Athlete created successfully.")
        |> redirect(to: ~p"/athletes/#{athlete}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    athlete = RaceSpace.get_athlete!(id, [:wave])
    render(conn, :show, athlete: athlete)
  end

  def edit(conn, %{"id" => id}) do
    athlete = RaceSpace.get_athlete!(id)
    changeset = RaceSpace.change_athlete(athlete)

    waves = get_waves()

    render(conn, :edit, athlete: athlete, changeset: changeset, waves: waves)
  end

  def update(conn, %{"id" => id, "athlete" => athlete_params}) do
    athlete = RaceSpace.get_athlete!(id)

    case RaceSpace.update_athlete(athlete, athlete_params) do
      {:ok, athlete} ->
        conn
        |> put_flash(:info, "Athlete updated successfully.")
        |> redirect(to: ~p"/athletes/#{athlete}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, athlete: athlete, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    athlete = RaceSpace.get_athlete!(id)
    {:ok, _athlete} = RaceSpace.delete_athlete(athlete)

    conn
    |> put_flash(:info, "Athlete deleted successfully.")
    |> redirect(to: ~p"/athletes")
  end

  defp get_waves do
    RaceSpace.list_waves()
    |> Enum.map(&{&1.name, &1.id})
  end
end
