defmodule CharmWeb.ContactList do
  alias Charm.Contacts
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    contacts = Contacts.list_contacts()
    {:ok, socket |> assign(contacts: contacts), layout: {CharmWeb.Layouts, :app}}
  end

  def render(assigns) do
    ~H"""
    <div>
      Contact List Content test
    </div>
    """
  end
end
