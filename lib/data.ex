defmodule UrlShortener.Data do
  @moduledoc false
  use Agent

  def start do
    File.mkdir_p!("data")
    :dets.open_file(:data_storage, type: :set, file: ~c"data/data.dets")
  end

  def stop do
    :dets.close(:data_storage)
  end

  def get_redirect_endpoint(incoming_endpoint) do
    case :dets.lookup(:data_storage, incoming_endpoint) do
      [{^incoming_endpoint, outgoing_endpoint}] -> {:ok, outgoing_endpoint}
      [] -> {:error, nil}
    end
  end

  def add_redirect_endpoint(incoming_endpoint, outgoing_endpoint) do
    case :dets.insert_new(:data_storage, {incoming_endpoint, outgoing_endpoint}) do
      true -> :ok
      false -> :conflict
    end
  end
end
