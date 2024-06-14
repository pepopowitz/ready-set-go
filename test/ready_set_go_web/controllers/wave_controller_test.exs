defmodule ReadySetGoWeb.WaveControllerTest do
  use ReadySetGoWeb.ConnCase

  import ReadySetGo.RaceSpaceFixtures

  @create_attrs %{index: 42, name: "some name", start_time: ~N[2024-06-13 02:03:00.000000], end_time: ~N[2024-06-13 02:03:00.000000]}
  @update_attrs %{index: 43, name: "some updated name", start_time: ~N[2024-06-14 02:03:00.000000], end_time: ~N[2024-06-14 02:03:00.000000]}
  @invalid_attrs %{index: nil, name: nil, start_time: nil, end_time: nil}

  describe "index" do
    test "lists all waves", %{conn: conn} do
      conn = get(conn, ~p"/waves")
      assert html_response(conn, 200) =~ "Listing Waves"
    end
  end

  describe "new wave" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/waves/new")
      assert html_response(conn, 200) =~ "New Wave"
    end
  end

  describe "create wave" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/waves", wave: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/waves/#{id}"

      conn = get(conn, ~p"/waves/#{id}")
      assert html_response(conn, 200) =~ "Wave #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/waves", wave: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wave"
    end
  end

  describe "edit wave" do
    setup [:create_wave]

    test "renders form for editing chosen wave", %{conn: conn, wave: wave} do
      conn = get(conn, ~p"/waves/#{wave}/edit")
      assert html_response(conn, 200) =~ "Edit Wave"
    end
  end

  describe "update wave" do
    setup [:create_wave]

    test "redirects when data is valid", %{conn: conn, wave: wave} do
      conn = put(conn, ~p"/waves/#{wave}", wave: @update_attrs)
      assert redirected_to(conn) == ~p"/waves/#{wave}"

      conn = get(conn, ~p"/waves/#{wave}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, wave: wave} do
      conn = put(conn, ~p"/waves/#{wave}", wave: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wave"
    end
  end

  describe "delete wave" do
    setup [:create_wave]

    test "deletes chosen wave", %{conn: conn, wave: wave} do
      conn = delete(conn, ~p"/waves/#{wave}")
      assert redirected_to(conn) == ~p"/waves"

      assert_error_sent 404, fn ->
        get(conn, ~p"/waves/#{wave}")
      end
    end
  end

  defp create_wave(_) do
    wave = wave_fixture()
    %{wave: wave}
  end
end
