defmodule ReadySetGo.RaceSpaceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReadySetGo.RaceSpace` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        end_time: ~N[2024-06-06 15:48:00.000000],
        name: "some name",
        start_time: ~N[2024-06-06 15:48:00.000000]
      })
      |> ReadySetGo.RaceSpace.create_event()

    event
  end
end