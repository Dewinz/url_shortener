defmodule Data do
  @moduledoc false
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_redirect_endpoint(incoming_endpoint) do
    outgoing_endpoint = Agent.get(__MODULE__, & Map.get(&1, incoming_endpoint))

    if outgoing_endpoint do
      {:ok, outgoing_endpoint}
    else
      {:error, outgoing_endpoint}
    end
  end

  def add_redirect_endpoint(incoming_endpoint, outgoing_endpoint) do
    # TODO: Check it starts with `http(s)://`.
    # TODO: Some kind of error handling on an already existing key?
    Agent.update(__MODULE__, fn data -> Map.put_new(data, incoming_endpoint, outgoing_endpoint) end)
    :ok
  end
end
