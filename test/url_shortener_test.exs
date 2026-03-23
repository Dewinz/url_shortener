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
      conn(:get, "/asdf")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 404
  end

  test "defined endpoint can be found" do
    conn(:post, "/asdf", "{ \"url\": \"https://google.com\" }")
    |> UrlShortener.Http.call(@opts)

    connection =
      conn(:get, "/asdf")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 301
  end

  test "endpoint can be defined" do
    connection =
      conn(:post, "/asdf", "{ \"url\": \"https://google.com\" }")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 201
  end

  test "already defined endpoint cannot be redefined" do
    conn(:post, "/asdf", "{ \"url\": \"https://google.com\" }")
    |> UrlShortener.Http.call(@opts)

    connection =
      conn(:post, "/asdf", "{ \"url\": \"https://google.com\" }")
      |> UrlShortener.Http.call(@opts)

    assert connection.status == 409
  end
end
