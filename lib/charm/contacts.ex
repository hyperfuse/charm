defmodule Charm.Contacts do
  alias Charm.Repo
  alias Charm.Contacts.Contact
  import Ecto.Query, only: [from: 2]

  @doc """
  List all the contacts in the database.
  """
  @spec list_contacts :: list(Contact.t())
  def list_contacts do
    query =
      from c in Charm.Contacts.Contact,
        order_by: [asc: c.last_name, asc: c.first_name]

    Repo.all(query)
  end
end
