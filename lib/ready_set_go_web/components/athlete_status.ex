defmodule ReadySetGoWeb.AthleteStatus do
  use Phoenix.Component

  attr :athlete, :map, required: true, doc: "the athlete"
  attr :wave, :map, required: false, doc: "the wave"

  def status(assigns) when not is_nil(assigns.athlete.start_time) do
    ~H"""
    <div class="mt-2">
      <strong class="font-bold">Start:</strong> <%= @athlete.start_time
      |> NaiveDateTime.truncate(:second)
      |> Time.to_string() %>
      <%= if @athlete.t1_time do %>
        <strong class="font-bold ml-4">T1:</strong> <%= @athlete.t1_time
        |> NaiveDateTime.truncate(:second)
        |> Time.to_string() %>
      <% end %>
      <%= if @athlete.t2_time do %>
        <strong class="font-bold ml-4">T2:</strong> <%= @athlete.t2_time
        |> NaiveDateTime.truncate(:second)
        |> Time.to_string() %>
      <% end %>
      <%= if @athlete.end_time do %>
        <strong class="font-bold ml-4">Finish:</strong> <%= @athlete.end_time
        |> NaiveDateTime.truncate(:second)
        |> Time.to_string() %>
      <% end %>
    </div>
    """
  end

  def status(assigns) when is_nil(assigns.athlete.start_time) do
    ~H"""
    <div class="mt-2">
      <strong class="font-bold"><%= @wave.name %></strong>
    </div>
    """
  end
end
