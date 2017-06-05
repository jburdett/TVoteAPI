defmodule MusicVoteApi.YoutubeServiceTest do
  use ExUnit.Case, async: true
  import MusicVoteApi.YoutubeService
  import Mock

  @search_attrs %{"artist" => "san+holo", "title" => "see+the+light"}

  test "returns the link ids from the youtube response" do
    youtube_results = %HTTPotion.Response{
      body: "{\n
        \"items\": [\n
          {\n
            \"id\": {\n \"videoId\": \"ULHeRdgeT54\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"q8GiCLDG-wg\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"Khvf1Rewvjc\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"bEB_DfTllOM\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"HBjCh2sMACQ\"\n }\n
          }\n
        ]\n
      }\n ",
      headers: %HTTPotion.Headers{hdrs: %{}},
      status_code: 200}


    with_mock HTTPotion, [get: fn(_) -> youtube_results end] do
      expected = ["ULHeRdgeT54", "q8GiCLDG-wg", "Khvf1Rewvjc", "bEB_DfTllOM", "HBjCh2sMACQ"]
      assert expected == search(@search_attrs)
    end
  end

  test "it searches youtube with valid params" do
    youtube_results = %HTTPotion.Response{
      body: "{\n
        \"items\": [\n
          {\n
            \"id\": {\n \"videoId\": \"ULHeRdgeT54\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"q8GiCLDG-wg\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"Khvf1Rewvjc\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"bEB_DfTllOM\"\n }\n
          },\n
          {\n
            \"id\": {\n \"videoId\": \"HBjCh2sMACQ\"\n }\n
          }\n
        ]\n
      }\n ",
      headers: %HTTPotion.Headers{hdrs: %{}},
      status_code: 200}

    with_mock HTTPotion, [get: fn(_) -> youtube_results end] do
      search(@search_attrs)
      assert called HTTPotion.get("https://www.googleapis.com/youtube/v3/search?part=id&type=video&q=see+the+light+san+holo&key=test")
    end
  end

  @space_attrs %{"artist" => "san holo", "title" => "see the light"}

  test "it subs out spaces in the query" do
    youtube_results = %HTTPotion.Response{
      body: "{\n
        \"items\": [\n
          {\n
            \"id\": {\n \"videoId\": \"BLAH\"\n }\n
          },\n
        ]\n
      }\n ",
      headers: %HTTPotion.Headers{hdrs: %{}},
      status_code: 200}

    with_mock HTTPotion, [get: fn(_) -> youtube_results end] do
      search(@space_attrs)
      assert called HTTPotion.get("https://www.googleapis.com/youtube/v3/search?part=id&type=video&q=see+the+light+san+holo&key=test")
    end
  end
end
