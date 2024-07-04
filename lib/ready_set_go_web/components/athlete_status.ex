defmodule ReadySetGoWeb.AthleteStatus do
  use Phoenix.Component

  # icons taken from https://icon-sets.iconify.design/ph/

  attr :athlete, :map, required: true, doc: "the athlete"
  attr :wave, :map, required: false, doc: "the wave"

  def status(assigns) when not is_nil(assigns.athlete.start_time) do
    ~H"""
    <div class="self-end">
      <div class="flex flex-row mt-2">
        <div>
          <.swim_duration athlete={@athlete} />
        </div>
        <div class="ml-4">
          <.bike_duration athlete={@athlete} />
        </div>
        <div class="ml-4">
          <.run_duration athlete={@athlete} />
        </div>
      </div>
    </div>
    """
  end

  def status(assigns) when is_nil(assigns.athlete.start_time) do
    ~H"""
    <div class="mt-2">
      <strong class="font-bold text-zinc-500"><em><%= @wave.name %></em></strong>
    </div>
    """
  end

  # active
  def swim_duration(assigns)
      when not is_nil(assigns.athlete.start_time) and is_nil(assigns.athlete.t1_time) do
    swim_duration = calculate_duration(assigns.athlete.start_time, DateTime.utc_now())
    assigns = assign(assigns, :swim_duration, swim_duration)

    ~H"""
    <div class="text-right text-brand">
      <span class="inline-block align-middle font-bold">
        <%= @swim_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="m90.44 108.6l6.24-6.24A83.54 83.54 0 0 0 56.24 92H40a12 12 0 0 1 0-24h16.24a107.28 107.28 0 0 1 76.36 31.64l40.25 40.25c10.74.27 22.11-3.64 35.49-14.73a12 12 0 1 1 15.32 18.47C205.49 158.7 189.06 164 174.15 164c-19.76 0-36.86-9.29-51.88-17.45c-25.06-13.61-44.86-24.36-74.61.31a12 12 0 1 1-15.32-18.48c21.73-18.02 40.96-22.06 58.1-19.78M140 72a36 36 0 1 1 36 36a36 36 0 0 1-36-36m24 0a12 12 0 1 0 12-12a12 12 0 0 0-12 12m44.34 109.16c-29.75 24.67-49.55 13.92-74.61.3c-26.35-14.3-59.14-32.11-101.39 2.93a12 12 0 1 0 15.32 18.47c29.75-24.66 49.55-13.92 74.61-.3c15 8.15 32.12 17.44 51.88 17.44c14.91 0 31.34-5.29 49.51-20.36a12 12 0 0 0-15.32-18.48"
          />
        </svg>
      </span>
    </div>
    """
  end

  # complete
  def swim_duration(assigns)
      when not is_nil(assigns.athlete.start_time) and not is_nil(assigns.athlete.t1_time) do
    swim_duration = calculate_duration(assigns.athlete.start_time, assigns.athlete.t1_time)
    assigns = assign(assigns, :swim_duration, swim_duration)

    ~H"""
    <div class="text-right text-green-700">
      <span class="inline-block align-middle font-bold">
        <%= @swim_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="m90.44 108.6l6.24-6.24A83.54 83.54 0 0 0 56.24 92H40a12 12 0 0 1 0-24h16.24a107.28 107.28 0 0 1 76.36 31.64l40.25 40.25c10.74.27 22.11-3.64 35.49-14.73a12 12 0 1 1 15.32 18.47C205.49 158.7 189.06 164 174.15 164c-19.76 0-36.86-9.29-51.88-17.45c-25.06-13.61-44.86-24.36-74.61.31a12 12 0 1 1-15.32-18.48c21.73-18.02 40.96-22.06 58.1-19.78M140 72a36 36 0 1 1 36 36a36 36 0 0 1-36-36m24 0a12 12 0 1 0 12-12a12 12 0 0 0-12 12m44.34 109.16c-29.75 24.67-49.55 13.92-74.61.3c-26.35-14.3-59.14-32.11-101.39 2.93a12 12 0 1 0 15.32 18.47c29.75-24.66 49.55-13.92 74.61-.3c15 8.15 32.12 17.44 51.88 17.44c14.91 0 31.34-5.29 49.51-20.36a12 12 0 0 0-15.32-18.48"
          />
        </svg>
      </span>
    </div>
    """
  end

  def swim_duration(assigns), do: ~H""

  # active
  def bike_duration(assigns)
      when not is_nil(assigns.athlete.t1_time) and is_nil(assigns.athlete.t2_time) do
    bike_duration = calculate_duration(assigns.athlete.t1_time, DateTime.utc_now())
    assigns = assign(assigns, :bike_duration, bike_duration)

    ~H"""
    <div class="text-right text-brand">
      <span class="inline-block align-middle font-bold">
        <%= @bike_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M168 84a32 32 0 1 0-32-32a32 32 0 0 0 32 32m0-40a8 8 0 1 1-8 8a8 8 0 0 1 8-8m36 96a40 40 0 1 0 40 40a40 40 0 0 0-40-40m0 56a16 16 0 1 1 16-16a16 16 0 0 1-16 16M54 136a42 42 0 1 0 42 42a42 42 0 0 0-42-42m0 60a18 18 0 1 1 18-18a18 18 0 0 1-18 18m134-68h-36a12 12 0 0 1-8.49-3.51L120 101l-15 15l31.52 31.51A12 12 0 0 1 140 156v48a12 12 0 0 1-24 0v-43l-36.49-36.51a12 12 0 0 1 0-17l32-32a12 12 0 0 1 17 0L157 104h31a12 12 0 0 1 0 24"
          />
        </svg>
      </span>
    </div>
    """
  end

  # completed
  def bike_duration(assigns)
      when not is_nil(assigns.athlete.t1_time) and not is_nil(assigns.athlete.t2_time) do
    bike_duration = calculate_duration(assigns.athlete.t1_time, assigns.athlete.t2_time)
    assigns = assign(assigns, :bike_duration, bike_duration)

    ~H"""
    <div class="text-right text-green-700">
      <span class="inline-block align-middle font-bold">
        <%= @bike_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M168 84a32 32 0 1 0-32-32a32 32 0 0 0 32 32m0-40a8 8 0 1 1-8 8a8 8 0 0 1 8-8m36 96a40 40 0 1 0 40 40a40 40 0 0 0-40-40m0 56a16 16 0 1 1 16-16a16 16 0 0 1-16 16M54 136a42 42 0 1 0 42 42a42 42 0 0 0-42-42m0 60a18 18 0 1 1 18-18a18 18 0 0 1-18 18m134-68h-36a12 12 0 0 1-8.49-3.51L120 101l-15 15l31.52 31.51A12 12 0 0 1 140 156v48a12 12 0 0 1-24 0v-43l-36.49-36.51a12 12 0 0 1 0-17l32-32a12 12 0 0 1 17 0L157 104h31a12 12 0 0 1 0 24"
          />
        </svg>
      </span>
    </div>
    """
  end

  def bike_duration(assigns) do
    ~H"""
    <div class="text-right text-gray-400">
      <span class="inline-block align-middle font-bold">
        --:--
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M168 84a32 32 0 1 0-32-32a32 32 0 0 0 32 32m0-40a8 8 0 1 1-8 8a8 8 0 0 1 8-8m36 96a40 40 0 1 0 40 40a40 40 0 0 0-40-40m0 56a16 16 0 1 1 16-16a16 16 0 0 1-16 16M54 136a42 42 0 1 0 42 42a42 42 0 0 0-42-42m0 60a18 18 0 1 1 18-18a18 18 0 0 1-18 18m134-68h-36a12 12 0 0 1-8.49-3.51L120 101l-15 15l31.52 31.51A12 12 0 0 1 140 156v48a12 12 0 0 1-24 0v-43l-36.49-36.51a12 12 0 0 1 0-17l32-32a12 12 0 0 1 17 0L157 104h31a12 12 0 0 1 0 24"
          />
        </svg>
      </span>
    </div>
    """
  end

  # active
  def run_duration(assigns)
      when not is_nil(assigns.athlete.t2_time) and is_nil(assigns.athlete.end_time) do
    run_duration = calculate_duration(assigns.athlete.t2_time, DateTime.utc_now())
    assigns = assign(assigns, :run_duration, run_duration)

    ~H"""
    <div class="text-right text-brand">
      <span class="inline-block align-middle text-brand font-bold">
        <%= @run_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M152 92a36 36 0 1 0-36-36a36 36 0 0 0 36 36m0-48a12 12 0 1 1-12 12a12 12 0 0 1 12-12m76 93.4a12 12 0 0 1-7 10.91a66 66 0 0 1-21.47 3.78c-14 0-34.25-3.82-59.77-19a177 177 0 0 1-10.27 21C153.12 162.83 188 183.8 188 232a12 12 0 0 1-24 0c0-18.69-6.95-33.06-21.26-43.94c-9.16-7-19.55-11-27.43-13.34c-.81 1-1.64 2-2.5 2.95c-20 22.87-44.82 34.76-72.25 34.76a97 97 0 0 1-9.75-.49a12 12 0 1 1 2.39-23.88c52.3 5.22 77.48-45.92 85.79-67.75c-34.19-17.85-55.25-1.53-55.48-1.31a12 12 0 0 1-15-18.72C50.08 99 88 69.44 142.75 106.62c43.1 29.31 68.1 19.92 68.5 19.76a12 12 0 0 1 16.75 11Z"
          />
        </svg>
      </span>
    </div>
    """
  end

  # completed
  def run_duration(assigns)
      when not is_nil(assigns.athlete.t2_time) and not is_nil(assigns.athlete.end_time) do
    run_duration = calculate_duration(assigns.athlete.t2_time, assigns.athlete.end_time)
    assigns = assign(assigns, :run_duration, run_duration)

    ~H"""
    <div class="text-right text-green-700">
      <span class="inline-block align-middle font-bold">
        <%= @run_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M152 92a36 36 0 1 0-36-36a36 36 0 0 0 36 36m0-48a12 12 0 1 1-12 12a12 12 0 0 1 12-12m76 93.4a12 12 0 0 1-7 10.91a66 66 0 0 1-21.47 3.78c-14 0-34.25-3.82-59.77-19a177 177 0 0 1-10.27 21C153.12 162.83 188 183.8 188 232a12 12 0 0 1-24 0c0-18.69-6.95-33.06-21.26-43.94c-9.16-7-19.55-11-27.43-13.34c-.81 1-1.64 2-2.5 2.95c-20 22.87-44.82 34.76-72.25 34.76a97 97 0 0 1-9.75-.49a12 12 0 1 1 2.39-23.88c52.3 5.22 77.48-45.92 85.79-67.75c-34.19-17.85-55.25-1.53-55.48-1.31a12 12 0 0 1-15-18.72C50.08 99 88 69.44 142.75 106.62c43.1 29.31 68.1 19.92 68.5 19.76a12 12 0 0 1 16.75 11Z"
          />
        </svg>
      </span>
    </div>
    """
  end

  # unstarted
  def run_duration(assigns) do
    ~H"""
    <div class="text-right text-gray-400">
      <span class="inline-block align-middle font-bold">
        --:--
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M152 92a36 36 0 1 0-36-36a36 36 0 0 0 36 36m0-48a12 12 0 1 1-12 12a12 12 0 0 1 12-12m76 93.4a12 12 0 0 1-7 10.91a66 66 0 0 1-21.47 3.78c-14 0-34.25-3.82-59.77-19a177 177 0 0 1-10.27 21C153.12 162.83 188 183.8 188 232a12 12 0 0 1-24 0c0-18.69-6.95-33.06-21.26-43.94c-9.16-7-19.55-11-27.43-13.34c-.81 1-1.64 2-2.5 2.95c-20 22.87-44.82 34.76-72.25 34.76a97 97 0 0 1-9.75-.49a12 12 0 1 1 2.39-23.88c52.3 5.22 77.48-45.92 85.79-67.75c-34.19-17.85-55.25-1.53-55.48-1.31a12 12 0 0 1-15-18.72C50.08 99 88 69.44 142.75 106.62c43.1 29.31 68.1 19.92 68.5 19.76a12 12 0 0 1 16.75 11Z"
          />
        </svg>
      </span>
    </div>
    """
  end

  # active
  def total_duration(assigns)
      when not is_nil(assigns.athlete.start_time) and is_nil(assigns.athlete.end_time) do
    total_duration = calculate_duration(assigns.athlete.start_time, DateTime.utc_now())
    assigns = assign(assigns, :total_duration, total_duration)

    ~H"""
    <div class="text-right text-gray-400">
      <span class="inline-block align-middle font-bold">
        <%= @total_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M128 44a96 96 0 1 0 96 96a96.11 96.11 0 0 0-96-96m0 168a72 72 0 1 1 72-72a72.08 72.08 0 0 1-72 72m36.49-112.49a12 12 0 0 1 0 17l-28 28a12 12 0 0 1-17-17l28-28a12 12 0 0 1 17 0M92 16a12 12 0 0 1 12-12h48a12 12 0 0 1 0 24h-48a12 12 0 0 1-12-12"
          />
        </svg>
      </span>
    </div>
    """
  end

  # complete
  def total_duration(assigns)
      when not is_nil(assigns.athlete.start_time) and not is_nil(assigns.athlete.end_time) do
    total_duration = calculate_duration(assigns.athlete.start_time, assigns.athlete.end_time)
    assigns = assign(assigns, :total_duration, total_duration)

    ~H"""
    <div class="text-right text-green-700">
      <span class="inline-block align-middle font-bold">
        <%= @total_duration %>
      </span>
      <span class="text-2xl inline-block align-middle">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 256 256">
          <path
            fill="currentColor"
            d="M232 60h-20V48a12 12 0 0 0-12-12H56a12 12 0 0 0-12 12v12H24A20 20 0 0 0 4 80v16a44.05 44.05 0 0 0 44 44h.77A84.18 84.18 0 0 0 116 195.15V212H96a12 12 0 0 0 0 24h64a12 12 0 0 0 0-24h-20v-16.89c30.94-4.51 56.53-26.2 67-55.11h1a44.05 44.05 0 0 0 44-44V80a20 20 0 0 0-20-20M28 96V84h16v28c0 1.21 0 2.41.09 3.61A20 20 0 0 1 28 96m160 15.1c0 33.33-26.71 60.65-59.54 60.9A60 60 0 0 1 68 112V60h120ZM228 96a20 20 0 0 1-16.12 19.62c.08-1.5.12-3 .12-4.52V84h16Z"
          />
        </svg>
      </span>
    </div>
    """
  end

  def total_duration(assigns), do: ~H""

  defp calculate_duration(start_time, end_time) do
    {:ok, proper_start_time} = DateTime.from_naive(start_time, "Etc/UTC")
    {:ok, proper_end_time} = DateTime.from_naive(end_time, "Etc/UTC")

    round(DateTime.diff(proper_end_time, proper_start_time, :second))
    |> format_duration()
  end

  defp format_duration(seconds_total) do
    minutes = div(seconds_total, 60) |> Integer.to_string() |> String.pad_leading(2, "0")
    seconds = rem(seconds_total, 60) |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{minutes}:#{seconds}"
  end
end
