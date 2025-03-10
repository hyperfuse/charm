defmodule Charm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CharmWeb.Telemetry,
      Charm.Repo,
      {DNSCluster, query: Application.get_env(:charm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Charm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Charm.Finch},
      # Start a worker by calling: Charm.Worker.start_link(arg)
      # {Charm.Worker, arg},
      # Start to serve requests, typically the last entry
      CharmWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Charm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CharmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
