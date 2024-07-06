defmodule ReadySetGoWeb.AthleteControllerTest do
  use ReadySetGoWeb.ConnCase

  import ReadySetGo.RaceSpaceFixtures

  @create_attrs %{
    name: "some name",
    number: 42,
    wave: 42,
    wave_index: 42,
    start_time: ~N[2024-06-18 02:51:00.000000],
    t1_time: ~N[2024-06-18 02:51:00.000000],
    t2_time: ~N[2024-06-18 02:51:00.000000],
    end_time: ~N[2024-06-18 02:51:00.000000]
  }
  @update_attrs %{
    name: "some updated name",
    number: 43,
    wave: 42,
    wave_index: 43,
    start_time: ~N[2024-06-19 02:51:00.000000],
    t1_time: ~N[2024-06-19 02:51:00.000000],
    t2_time: ~N[2024-06-19 02:51:00.000000],
    end_time: ~N[2024-06-19 02:51:00.000000]
  }
  @invalid_attrs %{
    name: nil,
    number: nil,
    wave: nil,
    wave_index: nil,
    start_time: nil,
    t1_time: nil,
    t2_time: nil,
    end_time: nil
  }

  describe "index" do
    test "lists all athletes", %{conn: conn} do
      conn = get(conn, ~p"/athletes")
      assert html_response(conn, 200) =~ "Listing Athletes"
    end
  end

  describe "new athlete" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/athletes/new")
      assert html_response(conn, 200) =~ "New Athlete"
    end
  end

  describe "create athlete" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/athletes", athlete: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/athletes/#{id}"

      conn = get(conn, ~p"/athletes/#{id}")
      assert html_response(conn, 200) =~ "Athlete #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/athletes", athlete: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Athlete"
    end
  end

  describe "edit athlete" do
    setup [:create_athlete]

    test "renders form for editing chosen athlete", %{conn: conn, athlete: athlete} do
      conn = get(conn, ~p"/athletes/#{athlete}/edit")
      assert html_response(conn, 200) =~ "Edit Athlete"
    end
  end

  describe "update athlete" do
    setup [:create_athlete]

    test "redirects when data is valid", %{conn: conn, athlete: athlete} do
      conn = put(conn, ~p"/athletes/#{athlete}", athlete: @update_attrs)
      assert redirected_to(conn) == ~p"/athletes/#{athlete}"

      conn = get(conn, ~p"/athletes/#{athlete}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, athlete: athlete} do
      conn = put(conn, ~p"/athletes/#{athlete}", athlete: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Athlete"
    end
  end

  describe "delete athlete" do
    setup [:create_athlete]

    test "deletes chosen athlete", %{conn: conn, athlete: athlete} do
      conn = delete(conn, ~p"/athletes/#{athlete}")
      assert redirected_to(conn) == ~p"/athletes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/athletes/#{athlete}")
      end
    end
  end

  defp create_athlete(_) do
    athlete = athlete_fixture()
    %{athlete: athlete}
  end
end
