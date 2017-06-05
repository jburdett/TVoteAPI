defmodule MusicVoteApi.TrackTest do
  use MusicVoteApi.ModelCase

  alias MusicVoteApi.Track

  @valid_attrs %{artist: "some content", link: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Track.changeset(%Track{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Track.changeset(%Track{}, @invalid_attrs)
    refute changeset.valid?
  end
end
