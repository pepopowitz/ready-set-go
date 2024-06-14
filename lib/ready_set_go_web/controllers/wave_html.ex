defmodule ReadySetGoWeb.WaveHTML do
  use ReadySetGoWeb, :html

  embed_templates "wave_html/*"

  @doc """
  Renders a wave form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def wave_form(assigns)
end
