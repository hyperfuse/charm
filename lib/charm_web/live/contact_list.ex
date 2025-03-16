defmodule CharmWeb.ContactList do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {CharmWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <div>
      Contact List Content test
    </div>
    """
  end
end
