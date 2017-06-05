defmodule MusicVoteApi.Repo.Migrations.CreateTrack do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :title, :string
      add :artist, :string
      add :link, :string

      timestamps()
    end

  end
end
