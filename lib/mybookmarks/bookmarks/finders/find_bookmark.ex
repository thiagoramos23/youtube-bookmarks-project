defmodule Mybookmarks.Bookmarks.Finders.FindBookmark do
  import Ecto.Query

  alias Mybookmarks.Repo
  alias Mybookmarks.Bookmarks.Bookmark

  def find(attrs \\ %{}) do
    query =
      base_query()
      |> filter(attrs)

    Repo.all(query)
  end

  defp base_query() do
    from bookmark in Bookmark,
      as: :bookmark,
      join: user in assoc(bookmark, :user),
      as: :user,
      order_by: [desc: bookmark.inserted_at]
  end

  defp filter(query, attrs) do
    Enum.reduce(attrs, query, &do_filter/2)
  end

  defp do_filter({:type, value}, query) do
    query
    |> where([bookmark: bookmark], bookmark.type == ^value)
  end

  defp do_filter({:user_id, value}, query) do
    query
    |> where([user: user], user.id == ^value)
  end

  defp do_filter({:search, value}, query) do
    query
    |> where(
      [bookmark: bookmark],
      ilike(bookmark.name, ^"%#{value}%") or ilike(bookmark.url, ^"%#{value}%")
    )
  end
end
