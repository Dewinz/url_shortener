defmodule UrlShortenerTest do
  @moduledoc false
  use ExUnit.Case
  import Plug.Test
  import Plug.Conn

  @opts UrlShortener.Http.init([])

  setup do
    :dets.delete_all_objects(:data_storage)
    :ok
  end

  test "undefined endpoint can not be found" do
    connection =
      :get
      |> conn("/asdf")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 404
  end

  test "defined endpoint can be found" do
    :post
    |> conn("/asdf", JSON.encode!(%{"url" => "https://google.com"}))
    |> UrlShortener.Http.call(@opts)

    connection =
      :get
      |> conn("/asdf")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 301
  end

  test "endpoint can be defined" do
    connection =
      :post
      |> conn("/asdf", JSON.encode!(%{"url" => "https://google.com"}))
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 201
  end

  test "already defined endpoint cannot be redefined" do
    :post
    |> conn("/asdf", JSON.encode!(%{"url" => "https://google.com"}))
    |> UrlShortener.Http.call(@opts)

    connection =
      :post
      |> conn("/asdf", JSON.encode!(%{"url" => "https://google.com"}))
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 409
  end
end
