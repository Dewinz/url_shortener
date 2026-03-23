defmodule Domain do
  @moduledoc false

  defmodule Url do
    @moduledoc false
    defstruct url: ""
  end

  def add_redirect_endpoint(incoming_endpoint, outgoing_endpoint) do
    IO.puts(outgoing_endpoint)
    if String.match?(outgoing_endpoint, ~r/^https?:\/\/.+$/) do
      Data.add_redirect_endpoint(incoming_endpoint, outgoing_endpoint)
    else
      :error
    end
  end
end
