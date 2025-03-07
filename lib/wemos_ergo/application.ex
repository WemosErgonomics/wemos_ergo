defmodule WemosErgo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WemosErgoWeb.Telemetry,
      WemosErgo.Repo,
      {DNSCluster, query: Application.get_env(:wemos_ergo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WemosErgo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WemosErgo.Finch},
      # Start a worker by calling: WemosErgo.Worker.start_link(arg)
      # {WemosErgo.Worker, arg},
      # Start to serve requests, typically the last entry
      WemosErgoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WemosErgo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WemosErgoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
