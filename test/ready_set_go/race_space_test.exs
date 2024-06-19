defmodule ReadySetGo.RaceSpaceTest do
  use ReadySetGo.DataCase

  alias ReadySetGo.RaceSpace

  describe "events" do
    alias ReadySetGo.RaceSpace.Event

    import ReadySetGo.RaceSpaceFixtures

    @invalid_attrs %{name: nil, start_time: nil, end_time: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert RaceSpace.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert RaceSpace.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", start_time: ~N[2024-06-06 15:48:00.000000], end_time: ~N[2024-06-06 15:48:00.000000]}

      assert {:ok, %Event{} = event} = RaceSpace.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.start_time == ~N[2024-06-06 15:48:00.000000]
      assert event.end_time == ~N[2024-06-06 15:48:00.000000]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RaceSpace.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", start_time: ~N[2024-06-07 15:48:00.000000], end_time: ~N[2024-06-07 15:48:00.000000]}

      assert {:ok, %Event{} = event} = RaceSpace.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.start_time == ~N[2024-06-07 15:48:00.000000]
      assert event.end_time == ~N[2024-06-07 15:48:00.000000]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = RaceSpace.update_event(event, @invalid_attrs)
      assert event == RaceSpace.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = RaceSpace.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> RaceSpace.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = RaceSpace.change_event(event)
    end
  end

  describe "waves" do
    alias ReadySetGo.RaceSpace.Wave

    import ReadySetGo.RaceSpaceFixtures

    @invalid_attrs %{index: nil, name: nil, start_time: nil, end_time: nil}

    test "list_waves/0 returns all waves" do
      wave = wave_fixture()
      assert RaceSpace.list_waves() == [wave]
    end

    test "get_wave!/1 returns the wave with given id" do
      wave = wave_fixture()
      assert RaceSpace.get_wave!(wave.id) == wave
    end

    test "create_wave/1 with valid data creates a wave" do
      valid_attrs = %{index: 42, name: "some name", start_time: ~N[2024-06-13 02:03:00.000000], end_time: ~N[2024-06-13 02:03:00.000000]}

      assert {:ok, %Wave{} = wave} = RaceSpace.create_wave(valid_attrs)
      assert wave.index == 42
      assert wave.name == "some name"
      assert wave.start_time == ~N[2024-06-13 02:03:00.000000]
      assert wave.end_time == ~N[2024-06-13 02:03:00.000000]
    end

    test "create_wave/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RaceSpace.create_wave(@invalid_attrs)
    end

    test "update_wave/2 with valid data updates the wave" do
      wave = wave_fixture()
      update_attrs = %{index: 43, name: "some updated name", start_time: ~N[2024-06-14 02:03:00.000000], end_time: ~N[2024-06-14 02:03:00.000000]}

      assert {:ok, %Wave{} = wave} = RaceSpace.update_wave(wave, update_attrs)
      assert wave.index == 43
      assert wave.name == "some updated name"
      assert wave.start_time == ~N[2024-06-14 02:03:00.000000]
      assert wave.end_time == ~N[2024-06-14 02:03:00.000000]
    end

    test "update_wave/2 with invalid data returns error changeset" do
      wave = wave_fixture()
      assert {:error, %Ecto.Changeset{}} = RaceSpace.update_wave(wave, @invalid_attrs)
      assert wave == RaceSpace.get_wave!(wave.id)
    end

    test "delete_wave/1 deletes the wave" do
      wave = wave_fixture()
      assert {:ok, %Wave{}} = RaceSpace.delete_wave(wave)
      assert_raise Ecto.NoResultsError, fn -> RaceSpace.get_wave!(wave.id) end
    end

    test "change_wave/1 returns a wave changeset" do
      wave = wave_fixture()
      assert %Ecto.Changeset{} = RaceSpace.change_wave(wave)
    end
  end

  describe "athletes" do
    alias ReadySetGo.RaceSpace.Athlete

    import ReadySetGo.RaceSpaceFixtures

    @invalid_attrs %{name: nil, number: nil, wave_index: nil, start_time: nil, t1_time: nil, t2_time: nil, end_time: nil}

    test "list_athletes/0 returns all athletes" do
      athlete = athlete_fixture()
      assert RaceSpace.list_athletes() == [athlete]
    end

    test "get_athlete!/1 returns the athlete with given id" do
      athlete = athlete_fixture()
      assert RaceSpace.get_athlete!(athlete.id) == athlete
    end

    test "create_athlete/1 with valid data creates a athlete" do
      valid_attrs = %{name: "some name", number: 42, wave_index: 42, start_time: ~N[2024-06-18 02:51:00.000000], t1_time: ~N[2024-06-18 02:51:00.000000], t2_time: ~N[2024-06-18 02:51:00.000000], end_time: ~N[2024-06-18 02:51:00.000000]}

      assert {:ok, %Athlete{} = athlete} = RaceSpace.create_athlete(valid_attrs)
      assert athlete.name == "some name"
      assert athlete.number == 42
      assert athlete.wave_index == 42
      assert athlete.start_time == ~N[2024-06-18 02:51:00.000000]
      assert athlete.t1_time == ~N[2024-06-18 02:51:00.000000]
      assert athlete.t2_time == ~N[2024-06-18 02:51:00.000000]
      assert athlete.end_time == ~N[2024-06-18 02:51:00.000000]
    end

    test "create_athlete/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RaceSpace.create_athlete(@invalid_attrs)
    end

    test "update_athlete/2 with valid data updates the athlete" do
      athlete = athlete_fixture()
      update_attrs = %{name: "some updated name", number: 43, wave_index: 43, start_time: ~N[2024-06-19 02:51:00.000000], t1_time: ~N[2024-06-19 02:51:00.000000], t2_time: ~N[2024-06-19 02:51:00.000000], end_time: ~N[2024-06-19 02:51:00.000000]}

      assert {:ok, %Athlete{} = athlete} = RaceSpace.update_athlete(athlete, update_attrs)
      assert athlete.name == "some updated name"
      assert athlete.number == 43
      assert athlete.wave_index == 43
      assert athlete.start_time == ~N[2024-06-19 02:51:00.000000]
      assert athlete.t1_time == ~N[2024-06-19 02:51:00.000000]
      assert athlete.t2_time == ~N[2024-06-19 02:51:00.000000]
      assert athlete.end_time == ~N[2024-06-19 02:51:00.000000]
    end

    test "update_athlete/2 with invalid data returns error changeset" do
      athlete = athlete_fixture()
      assert {:error, %Ecto.Changeset{}} = RaceSpace.update_athlete(athlete, @invalid_attrs)
      assert athlete == RaceSpace.get_athlete!(athlete.id)
    end

    test "delete_athlete/1 deletes the athlete" do
      athlete = athlete_fixture()
      assert {:ok, %Athlete{}} = RaceSpace.delete_athlete(athlete)
      assert_raise Ecto.NoResultsError, fn -> RaceSpace.get_athlete!(athlete.id) end
    end

    test "change_athlete/1 returns a athlete changeset" do
      athlete = athlete_fixture()
      assert %Ecto.Changeset{} = RaceSpace.change_athlete(athlete)
    end
  end
end
