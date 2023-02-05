defmodule Mybookmarks.Repo.Migrations.AddUserToBookmarks do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:bookmarks, [:user_id])
  end
end
