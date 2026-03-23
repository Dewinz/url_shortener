defmodule UrlShortener do
  @moduledoc false

  def start(:normal, _start_options) do
    UrlShortener.Data.start()

    children = [
      {Bandit, plug: Http, port: Application.fetch_env!(:url_shortener, :port)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Server)
  end
end
