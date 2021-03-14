defmodule ScoredTest do
  use ExUnit.Case
  doctest Scored

  test "greets the world" do
    assert Scored.hello() == :world
  end
end
