defmodule MusicVoteApi.TrackController do
  use MusicVoteApi.Web, :controller

  alias MusicVoteApi.Track

  def index(conn, _params) do
    tracks = Repo.all(Track)
    render(conn, "index.json", tracks: tracks)
  end

  def find_links(conn, %{"track" => track_params}) do
    case MusicVoteApi.YoutubeService.search(track_params) do
      {:ok, links} ->
        render(conn, "links.json", %{links: links})
      {:error, errors} ->
        conn
        |> put_status(500)
        |> render(MusicVoteApi.ErrorView, "error.json", %{errors: errors})
    end
  end

  def create(conn, %{"track" => track_params}) do
    changeset = Track.changeset(%Track{}, track_params)

    case Repo.insert(changeset) do
      {:ok, track} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", track_path(conn, :show, track))
        |> render("show.json", track: track)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MusicVoteApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    track = Repo.get!(Track, id)
    render(conn, "show.json", track: track)
  end

  def update(conn, %{"id" => id, "track" => track_params}) do
    track = Repo.get!(Track, id)
    changeset = Track.changeset(track, track_params)

    case Repo.update(changeset) do
      {:ok, track} ->
        render(conn, "show.json", track: track)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MusicVoteApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    track = Repo.get!(Track, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(track)

    send_resp(conn, :no_content, "")
  end
end
