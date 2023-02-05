defmodule Mybookmarks.BookmarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mybookmarks.Bookmars` context.
  """

  @doc """
  Generate a bookmark.
  """
  def bookmark_fixture(attrs \\ %{}) do
    {:ok, bookmark} =
      attrs
      |> Enum.into(%{
        favorite: true,
        name: "some name",
        type: "some type",
        url: "some url"
      })
      |> Mybookmarks.Bookmars.create_bookmark()

    bookmark
  end
end
