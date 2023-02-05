defmodule Mybookmarks.Bookmarks do
  @moduledoc """
  The Bookmars context.
  """

  import Ecto.Query, warn: false
  alias Mybookmarks.Repo

  alias Mybookmarks.Bookmarks.Finders.FindBookmark
  alias Mybookmarks.Bookmarks.Bookmark

  @doc """
  Returns the list of bookmarks.

  ## Examples

      iex> list_bookmarks()
      [%Bookmark{}, ...]

  """
  def list_bookmarks do
    Repo.all(Bookmark)
  end

  def list_bookmarks_by_user(user_id, type \\ :read_it_later) do
    FindBookmark.find(%{user_id: user_id, type: type})
  end

  def search_bookmarks(user_id, search) do
    FindBookmark.find(%{user_id: user_id, search: search})
  end

  @doc """
  Gets a single bookmark.

  Raises `Ecto.NoResultsError` if the Bookmark does not exist.

  ## Examples

      iex> get_bookmark!(123)
      %Bookmark{}

      iex> get_bookmark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookmark!(id), do: Repo.get!(Bookmark, id)

  @doc """
  Creates a bookmark.

  ## Examples

      iex> create_bookmark(%{field: value})
      {:ok, %Bookmark{}}

      iex> create_bookmark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookmark(attrs \\ %{}) do
    %Bookmark{}
    |> Bookmark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bookmark.

  ## Examples

      iex> update_bookmark(bookmark, %{field: new_value})
      {:ok, %Bookmark{}}

      iex> update_bookmark(bookmark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bookmark.

  ## Examples

      iex> delete_bookmark(bookmark)
      {:ok, %Bookmark{}}

      iex> delete_bookmark(bookmark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookmark changes.

  ## Examples

      iex> change_bookmark(bookmark)
      %Ecto.Changeset{data: %Bookmark{}}

  """
  def change_bookmark(%Bookmark{} = bookmark, attrs \\ %{}) do
    Bookmark.changeset(bookmark, attrs)
  end
end
