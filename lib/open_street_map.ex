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
  def search(args) do
    call("search", args)
  end

  def reverse(args) do
    call("reverse", args)
  end

  defp call(type, args) do
    generate_url(type, args)
    |> prepare_url(type)
    |> fetch
  end

  defp generate_url(type, args) do
    Enum.filter(args, fn({key, _value}) -> Enum.member?(valid_args(type), key) end)
    |> List.foldl("", fn({key, value}, acc) -> acc <> add_to_options(key, to_string(value), acc) end)
  end

  defp valid_args(type) do
    case type do
      "search" -> [:q, :format, :addressdetails, :extratags, :namedetails, :viewbox, :bounded, :exclude_place_ids, :limit, :accept_language, :email]
      "reverse" -> [:format, :lat, :lon, :zoom, :addressdetails, :extratags, :namedetails, :accept_language, :email]
      _ -> []
    end
  end

  defp add_to_options(key, value, "") do
    "?" <> key_value_param(key, modify_search(value))
  end

  defp add_to_options(key, value, _acc) do
    "&" <> key_value_param(key, modify_search(value))
  end

  defp modify_search(value) do
    String.replace(value, ~r/\s+/, "+")
  end

  defp key_value_param(:accept_language, value) do
    "accept-language=" <> value
  end

  defp key_value_param(key, value) do
    "#{key}=#{value}"
  end

  defp prepare_url(url, type) do
    type <> url
  end

  defp fetch(url) do
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
end
