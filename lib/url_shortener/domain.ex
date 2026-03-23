defmodule UrlShortener.Domain do
  @moduledoc false

  def add_redirect_endpoint(incoming_endpoint, outgoing_endpoint) do
    if String.match?(outgoing_endpoint, ~r/^https?:\/\/.+$/) do
      UrlShortener.Data.add_redirect_endpoint(incoming_endpoint, outgoing_endpoint)
    else
      :error
    end
  end
end
