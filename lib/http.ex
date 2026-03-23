defmodule Http do
  @moduledoc false
  import Plug.Conn

  def init(options) do
    options
  end

  def call(connection, _options) do
    case connection.method do
      "GET" -> handle_get(connection)
      "POST" -> handle_post(connection)
    end
  end

  defp handle_get(connection) do
    {status, outgoing_endpoint} = Data.get_redirect_endpoint(connection.request_path)

    case status do
      :ok -> handle_get_success(connection, outgoing_endpoint)
      :error -> handle_get_fail(connection)
    end
  end

  defp handle_get_success(connection, outgoing_endpoint) do
    connection
    |> put_resp_header("location", outgoing_endpoint)
    |> send_resp(301, "")
  end

  defp handle_get_fail(connection) do
    connection
    |> send_resp(404, "")
  end

  defp handle_post(connection) do
    # TODO: Do there need to be rules for this?
    incoming_endpoint = connection.request_path

    {:ok, request_body, connection} = read_body(connection)
    {:ok, map} = JSON.decode(request_body)

    :ok =
      Domain.add_redirect_endpoint(incoming_endpoint, map["url"])

    connection
    |> send_resp(201, incoming_endpoint)
  end
end
