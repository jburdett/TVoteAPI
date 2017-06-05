defmodule MusicVoteApi.TrackControllerTest do
  use MusicVoteApi.ConnCase
  import Mock

  alias MusicVoteApi.Track
  @valid_attrs %{artist: "some content", link: "some content", title: "some content"}
  @find_attrs %{artist: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, track_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = get conn, track_path(conn, :show, track)
    assert json_response(conn, 200)["data"] == %{"id" => track.id,
      "title" => track.title,
      "artist" => track.artist,
      "link" => track.link}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, track_path(conn, :show, -1)
    end
  end

  test "searches youtube and renders link ids", %{conn: conn} do
    links_ids = ["ULHeRdgeT54", "q8GiCLDG-wg", "Khvf1Rewvjc", "bEB_DfTllOM", "HBjCh2sMACQ"]
    with_mock MusicVoteApi.YoutubeService, [search: fn(_) -> links_ids end] do
      conn = post conn, track_path(conn, :find_links), track: @find_attrs
      assert json_response(conn, 200)["links"] == links_ids
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, track_path(conn, :create), track: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Track, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, track_path(conn, :create), track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = put conn, track_path(conn, :update, track), track: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Track, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = put conn, track_path(conn, :update, track), track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = delete conn, track_path(conn, :delete, track)
    assert response(conn, 204)
    refute Repo.get(Track, track.id)
  end
end
