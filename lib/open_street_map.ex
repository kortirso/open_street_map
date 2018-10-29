defmodule OpenStreetMap do
  @moduledoc """
  Documentation for OpenStreetMap.
  """

  @doc """
  Hello world.

  ## Examples

      iex> OpenStreetMap.hello()
      :world

  """
  def fetch(url) do
    base_url = "https://nominatim.openstreetmap.org/"
    headers = ["Accept": "Application/json; Charset=utf-8"]
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    case HTTPoison.get(base_url <> url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def search(args) do
    generate_url(args)
    |> prepare_url("search")
    |> fetch
  end

  def generate_url(args) do
    Enum.filter(args, fn({key, _value}) -> Enum.member?(valid_search_args(), key) end)
    |> List.foldl("", fn({key, value}, acc) -> acc <> add_to_options(key, to_string(value), acc) end)
  end

  def valid_search_args do
    [:q, :format, :addressdetails, :extratags, :namedetails, :viewbox, :bounded, :exclude_place_ids, :limit, :accept_language, :email]
  end

  def add_to_options(key, value, "") do
    "?" <> key_value_param(key, modify_search(value))
  end

  def add_to_options(key, value, _acc) do
    "&" <> key_value_param(key, modify_search(value))
  end

  def key_value_param(:accept_language, value) do
    "accept-language=" <> value
  end

  def key_value_param(key, value) do
    "#{key}=#{value}"
  end

  def modify_search(value) do
    String.replace(value, ~r/\s+/, "+")
  end

  def prepare_url(type, url) do
    type <> url
  end
end
