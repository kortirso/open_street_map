defmodule OpenStreetMap.Client do
  @moduledoc """
  Client requests
  """

  @type api_key :: {:api_key, String.t()}
  @type path :: String.t()

  @doc """
  Performs a request

  ## Examples

      iex> OpenStreetMap.Client.call("search", args)

  """
  @spec call(String.t(), list) :: {}

  def call(type, args) when type in ["search", "reverse"] and is_list(args) do
    type
    |> generate_url(args)
    |> fetch(args)
    |> parse(args[:format])
  end

  # MAIN FUNCTIONS

  # generate url with all params
  defp generate_url(type, args) do
    args
    |> Stream.filter(fn {key, _} -> Enum.member?(valid_args(type), key) end)
    |> Stream.map(fn {key, value} -> "#{modify_key(key)}=#{URI.encode_www_form(value)}" end)
    |> Enum.join("&")
    |> prepare_url(type)
  end

  # make request
  defp fetch(url, args) do
    case HTTPoison.get(base_url(args) <> url, headers(args), request_options(args)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  # parse result
  defp parse({result, :timeout}, format) when format in ["json", "jsonv2"], do: {result, :timeout}
  defp parse({result, response}, format) when format in ["json", "jsonv2"], do: {result, Jason.decode!(response)}
  defp parse(response, _), do: response

  # ADDITIONAL FUNCTIONS

  # list with available options based on request type
  defp valid_args(type) do
    case type do
      "search" -> [:q, :format, :addressdetails, :extratags, :namedetails, :viewbox, :bounded, :exclude_place_ids, :limit, :accept_language, :email]
      "reverse" -> [:format, :lat, :lon, :zoom, :addressdetails, :extratags, :namedetails, :accept_language, :email]
      _ -> []
    end
  end

  # Modify accept-language key
  defp modify_key(:accept_language), do: "accept-language"
  defp modify_key(key), do: key

  # add type of request to url
  defp prepare_url(url, type), do: "#{type}?#{url}"

  # define params for request
  defp base_url(args), do: args[:hostname] || "https://nominatim.openstreetmap.org/"

  defp headers(args), do: [{"Content-Type", "application/json"}, {"User-Agent", user_agent(args[:user_agent])}, {"Accept", "Application/json; Charset=utf-8"}]

  defp request_options(args), do: args[:request_options] || []

  # define UserAgent for request
  defp user_agent(nil), do: "hex/open_street_map/#{random_string(16)}"
  defp user_agent(value), do: value

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
