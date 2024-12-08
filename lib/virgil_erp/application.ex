defmodule VirgilErp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VirgilErpWeb.Telemetry,
      VirgilErp.Repo,
      {DNSCluster, query: Application.get_env(:virgil_erp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VirgilErp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: VirgilErp.Finch},
      # Start a worker by calling: VirgilErp.Worker.start_link(arg)
      # {VirgilErp.Worker, arg},
      # Start to serve requests, typically the last entry
      VirgilErpWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VirgilErp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VirgilErpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
