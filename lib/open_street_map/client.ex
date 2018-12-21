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
      {:ok, [%{}]}

  """
  @spec call(String.t() , list) :: {}

  def call(type, args) do
    type
    |> generate_url(args)
    |> fetch(args)
    |> parse(args[:format])
  end

  # MAIN FUNCTIONS

  # generate url with all params
  defp generate_url(type, args) do
    args
    |> Enum.filter(fn {key, _} -> Enum.member?(valid_args(type), key) end)
    |> List.foldl("", fn {key, value}, acc -> acc <> add_to_args(key, to_string(value), acc) end)
    |> add_type_to_url(type)
  end

  defp fetch(url, args) do
    case HTTPoison.get(base_url(args) <> url, headers(args), options()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} -> {:error, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "Page not found"}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      true -> {:error, "Unknown error"}
    end
  end

  defp parse({:ok, response}, format) when format in ["json", "jsonv2"], do: {:ok, Poison.Parser.parse!(response)}
  defp parse({:ok, response}, _), do: {:ok, response}
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

  # first param in url params
  defp add_to_args(key, value, ""), do: "?" <> key_value_param(key, modify_search(value))
  defp add_to_args(key, value, _), do: "&" <> key_value_param(key, modify_search(value))

  # Modify all phrases with replacing spaces for +
  defp modify_search(value), do: String.replace(value, ~r/\s+/, "+")

  # Attach keys and values for url params string
  defp key_value_param(:accept_language, value), do: "accept-language=" <> value
  defp key_value_param(key, value), do: "#{key}=#{value}"

  # add type of request to url
  defp add_type_to_url(url, type), do: type <> url

  # define params for request
  defp base_url(args), do: args[:hostname] || "https://nominatim.openstreetmap.org/"

  defp headers(args), do: [{"Content-Type", "application/json"}, {"User-Agent", user_agent(args[:user_agent])}, {"Accept", "Application/json; Charset=utf-8"}]

  defp options, do: [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

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
