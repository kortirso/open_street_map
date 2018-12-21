defmodule OpenStreetMapTest do
  use ExUnit.Case

  test "makes reverse geocoding request and returns data" do
    {code, body} = OpenStreetMap.reverse([format: "json", lat: "52.594417", lon: "39.493115", accept_language: "en"])
    assert code == :ok
    assert map_size(body) != 0
  end

  test "makes search request and returns data" do
    {code, body} = OpenStreetMap.search([format: "json", q: "135 pilkington avenue, birmingham"])
    assert code == :ok
    assert length(body) != 0
  end

  test "makes reverse geocoding request and returns error for wrong data" do
    {code, body} = OpenStreetMap.reverse([lat: "52.594417"])
    assert code == :error
    assert String.length(body) != 0
  end
end
