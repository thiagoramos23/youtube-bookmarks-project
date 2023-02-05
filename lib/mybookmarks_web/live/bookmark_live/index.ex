defmodule MybookmarksWeb.BookmarkLive.Index do
  use MybookmarksWeb, :live_view
  import MybookmarksWeb.BookmarkLive.BookmarkComponents

  alias Mybookmarks.Bookmarks
  alias Mybookmarks.Bookmarks.Bookmark

  @empty ""

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       :bookmarks,
       list_bookmarks_by_user_and_type(current_user(socket).id, "read_it_later")
     )
     |> assign(:query_term, nil)
     |> assign(:type, "read_it_later")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bookmark")
    |> assign(:bookmark, Bookmarks.get_bookmark!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bookmark")
    |> assign(:bookmark, %Bookmark{})
  end

  defp apply_action(socket, :index, %{"type" => type}) do
    socket
    |> assign(:page_title, "Listing Bookmarks")
    |> assign(:bookmarks, list_bookmarks_by_user_and_type(current_user(socket).id, type))
    |> assign(:type, type)
    |> assign(:bookmark, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bookmarks")
    |> assign(:bookmark, nil)
  end

  @impl true
  def handle_event("search", %{"search" => query_term}, socket) do
    bookmarks = Bookmarks.search_bookmarks(current_user(socket).id, query_term)

    {:noreply,
     socket
     |> assign(:type, @empty)
     |> assign(:bookmarks, bookmarks)
     |> assign(:query_term, query_term)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bookmark = Bookmarks.get_bookmark!(id)
    {:ok, _} = Bookmarks.delete_bookmark(bookmark)

    {:noreply,
     socket
     |> assign(
       :bookmarks,
       list_bookmarks_by_user_and_type(current_user(socket).id, bookmark.type)
     )}
  end

  defp list_bookmarks_by_user_and_type(user_id, type) do
    Bookmarks.list_bookmarks_by_user(user_id, type)
  end

  defp current_user(socket) do
    socket.assigns.current_user
  end
end
