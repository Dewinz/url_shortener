defmodule UrlShortener.Http do
  @moduledoc false
  use Plug.Router

  plug :match
  plug :dispatch

  get "/:incoming_endpoint" do
    handle_get(conn, incoming_endpoint)
  end
  post "/:incoming_endpoint" do
    handle_post(conn, incoming_endpoint)
  end

  defp handle_get(connection, incoming_endpoint) do
    {status, outgoing_endpoint} = UrlShortener.Data.get_redirect_endpoint(incoming_endpoint)

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

  defp handle_post(connection, incoming_endpoint) do
    case read_body(connection) do
      {:ok, request_body, connection} ->
        parse_json_and_add_redirect_endpoint(connection, request_body, incoming_endpoint)

      _ ->
        send_resp(connection, 400, "No request body given")
    end
  end

  defp parse_json_and_add_redirect_endpoint(connection, request_body, incoming_endpoint) do
    case JSON.decode(request_body) do
      {:ok, map} ->
        case UrlShortener.Domain.add_redirect_endpoint(incoming_endpoint, map["url"]) do
          :ok -> send_resp(connection, 201, "")
          :conflict -> send_resp(connection, 409, "Route #{incoming_endpoint} is already in use")
          :error -> send_resp(connection, 400, "Expected body: { \"url\": \"^https?://...\" }")
        end

      _ ->
        send_resp(connection, 400, "Invalid JSON given.")
    end
  end
end
