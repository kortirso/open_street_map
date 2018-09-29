defmodule OpenStreetMapTest do
  use ExUnit.Case
  doctest OpenStreetMap

  test "greets the world" do
    assert OpenStreetMap.hello() == :world
  end
end
