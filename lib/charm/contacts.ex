defmodule Charm.Contacts do
  alias Charm.Repo
  alias Charm.Contacts.Contact

  @doc """
  List all the contacts in the database.
  """
  @spec list_contacts :: list(Contact.t())
  def list_contacts do
    Repo.all(Contact)
  end
end
