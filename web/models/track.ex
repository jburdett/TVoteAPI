defmodule MusicVoteApi.Track do
  use MusicVoteApi.Web, :model

  schema "tracks" do
    field :title, :string
    field :artist, :string
    field :link, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :artist, :link])
    |> validate_required([:title, :artist, :link])
  end
end
