defmodule CharmWeb.ContactList do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      Contact List Content
    </div>
    """
  end
end
