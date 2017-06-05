defmodule MusicVoteApi.TrackView do
  use MusicVoteApi.Web, :view

  def render("index.json", %{tracks: tracks}) do
    %{data: render_many(tracks, MusicVoteApi.TrackView, "track.json")}
  end

  def render("show.json", %{track: track}) do
    %{data: render_one(track, MusicVoteApi.TrackView, "track.json")}
  end

  def render("links.json", %{links: links}) do
    %{links: links}
  end

  def render("track.json", %{track: track}) do
    %{id: track.id,
      title: track.title,
      artist: track.artist,
      link: track.link}
  end
end
