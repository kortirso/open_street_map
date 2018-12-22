defmodule OpenStreetMap do
  @moduledoc """
  Elixir client for Nominatim OpenStreetMap API
  """

  alias OpenStreetMap.Client

  @doc """
  Search objects by query

  ## Example

      iex> OpenStreetMap.search([q: "135 pilkington avenue, birmingham", format: "json", addressdetails: "1", accept_language: "en"])
      {:ok, [%{"address" => %{},...}]}

  ### Options

      q - query, required
      format - one of the [xml|json|jsonv2], default - xml
      viewbox - The preferred area to find search results like <x1>,<y1>,<x2>,<y2>
      bounded - Restrict the results to only items contained with the viewbox, one of the [0|1]
      addressdetails - Include a breakdown of the address into elements, one of the [0|1]
      exclude_place_ids - If you do not want certain openstreetmap objects to appear in the search result, give a comma separated list of the place_id's you want to skip
      limit - Limit the number of returned results, integer
      extratags - Include additional information in the result if available, one of the [0|1]
      namedetails - Include a list of alternative names in the results, one of the [0|1]
      accept_language - Preferred language order for showing search results, default - en
      email - If you are making large numbers of request please include a valid email address
      hostname - allow overwriting the host name for users who have their own Nominatim installation, default - https://nominatim.openstreetmap.org/
      user_agent - User-Agent identifying the application, default - hex/open_street_map/random

  """
  @spec search(keyword()) :: {:ok, list}

  def search(options) when is_list(options), do: Client.call("search", options)

  @doc """
  Reverse geocoding generates an address from a latitude and longitude

  ## Example

      iex> OpenStreetMap.reverse([format: "json", lat: "52.594417", lon: "39.493115", accept_language: "en"])
      {:ok, %{"address" => %{},...}}

  ### Options

      lat - Latitude, required
      lon - Longitude, required
      format - one of the [xml|json|jsonv2], default - xml
      zoom - Level of detail required where 0 is country and 18 is house/building, one of the [0-18]
      addressdetails - Include a breakdown of the address into elements, one of the [0|1]
      extratags - Include additional information in the result if available, one of the [0|1]
      namedetails - Include a list of alternative names in the results, one of the [0|1]
      accept_language - Preferred language order for showing search results, default - en
      email - If you are making large numbers of request please include a valid email address
      hostname - allow overwriting the host name for users who have their own Nominatim installation, default - https://nominatim.openstreetmap.org/
      user_agent - User-Agent identifying the application, default - hex/open_street_map/random

  """
  @spec reverse(keyword()) :: {:ok, %{}}

  def reverse(options) when is_list(options), do: Client.call("reverse", options)
end
