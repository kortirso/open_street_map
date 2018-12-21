defmodule OpenStreetMap do
  @moduledoc """
  Elixir client for Nominatim OpenStreetMap API
  """

  alias OpenStreetMap.Client

  @doc """
  Search objects by query

  ## Example

      iex> OpenStreetMap.search(q: "135 pilkington avenue, birmingham", format: "json", addressdetails: "1", accept_language: "en")
      {:ok, [%{"address" => %{},...}]}

  """
  @spec search(keyword()) :: tuple()

  def search(options) when is_list(options), do: Client.call("search", options)

  @doc """
  Reverse geocoding generates an address from a latitude and longitude

  ## Example

      iex> OpenStreetMap.reverse(format: "json", lat: "52.594417", lon: "39.493115", accept_language: "en")
      {:ok, %{"address" => %{},...}}

  """
  @spec reverse(keyword()) :: tuple()

  def reverse(options) when is_list(options), do: Client.call("reverse", options)
end
