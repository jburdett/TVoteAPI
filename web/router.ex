defmodule MusicVoteApi.Router do
  use MusicVoteApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MusicVoteApi do
    pipe_through :api

    resources "/tracks", TrackController
    post "/tracks/find_links", TrackController, :find_links
  end
end
