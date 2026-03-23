defmodule UrlShortener.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    UrlShortener.Data.start()

    children = [
      {Bandit, plug: UrlShortener.Http, port: Application.fetch_env!(:url_shortener, :port)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Server)
  end

  def stop(_state) do
    UrlShortener.Data.stop()
  end
end
