defmodule CharmWeb.PageController do
  use CharmWeb, :controller
  import Phoenix.LiveView.Controller

  def home(conn, _params) do
    live_render(conn, ContactList, session: %{})
  end
end
