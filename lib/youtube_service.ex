defmodule MusicVoteApi.YoutubeService do
  @api_key Confex.get(:music_vote_api, :api_key)
  @youtube_url "https://www.googleapis.com/youtube/v3"

  def search(%{"artist" => artist, "title" => title}) do
    artist = String.replace(artist, " ", "+")
    title = String.replace(title, " ", "+")
    response = HTTPotion.get "#{@youtube_url}/search?part=id&type=video&q=#{title}+#{artist}&key=#{@api_key}"
    results = JSON.decode(response.body)
    if HTTPotion.Response.success?(response) do
      items = elem(results, 1)["items"]
      {:ok, Enum.map(items, fn x -> x["id"]["videoId"] end)}
    else
      errors = elem(results, 1)["error"]["errors"]
      {:error, errors}
    end
  end
end
