# OpenStreetMap

Integration of OpenStreetMap api from [Nominatim](https://wiki.openstreetmap.org/wiki/Nominatim)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `open_street_map` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:open_street_map, "0.9.2"}
  ]
end
```

## Usage

### Search

Request for search objects is #search.

```elixir
  OpenStreetMap.search(q: '135 pilkington avenue, birmingham', format: 'json', addressdetails: '1', accept_language: 'en')
```
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

#### Responces

```elixir
  {:ok,
    [
      %{
        "address" => %{
          "city" => "Birmingham",
          "country" => "United Kingdom",
          "country_code" => "gb",
          "county" => "West Midlands Combined Authority",
          "house_number" => "135",
          "postcode" => "B72 1LH",
          "road" => "Pilkington Avenue",
          "state" => "England",
          "state_district" => "West Midlands",
          "town" => "Sutton Coldfield"
        },
        "boundingbox" => ["52.5487473", "52.5488481", "-1.816513", "-1.8163464"],
        "class" => "building",
        "display_name" => "135, Pilkington Avenue, Sutton Coldfield, Birmingham, West Midlands Combined Authority, West Midlands, England, B72 1LH, United Kingdom",
        "importance" => 0.411,
        "lat" => "52.5487921",
        "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
        "lon" => "-1.8164308339635",
        "osm_id" => "90394480",
        "osm_type" => "way",
        "place_id" => "95707153",
        "type" => "yes"
      }
    ]
  }
```

### Reverse

Request for objects by coordinates is #reverse.

```elixir
  OpenStreetMap.reverse(format: 'json', lat: '52.594417', lon: '39.493115', accept_language: 'en')
```
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

#### Responces

```elixir
  {:ok,
    %{
      "address" => %{
        "city" => "Lipetsk",
        "city_district" => "Советский округ",
        "country" => "Russia",
        "country_code" => "ru",
        "house_number" => "4",
        "postcode" => "398000",
        "residential" => "микрорайон Елецкий",
        "road" => "улица Хренникова",
        "state" => "Lipetsk Oblast",
        "suburb" => "Lipetsk"
      },
      "boundingbox" => ["52.5943024", "52.5946223", "39.4929211", "39.4933486"],
      "display_name" => "4, улица Хренникова, микрорайон Елецкий, Сырский рудник, Советский округ, Lipetsk, Lipetsk Oblast, Central Federal District, 398000, Russia",
      "lat" => "52.5944624",
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
      "lon" => "39.4931348495468",
      "osm_id" => "367091730",
      "osm_type" => "way",
      "place_id" => "157477838"
    }
  }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kortirso/open_street_map.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Disclaimer

Use this package at your own peril and risk, the author tried to simplify the use of [Nominatim service](https://wiki.openstreetmap.org/wiki/Nominatim) for integration into Phoenix web applications.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/open_street_map](https://hexdocs.pm/open_street_map).
