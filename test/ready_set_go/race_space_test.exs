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
end
