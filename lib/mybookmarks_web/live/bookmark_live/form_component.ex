defmodule MybookmarksWeb.BookmarkLive.FormComponent do
  use MybookmarksWeb, :live_component

  alias Mybookmarks.Bookmarks
  alias Mybookmarks.Bookmarks.Bookmark

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bookmark records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="bookmark-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :user_id}} type="hidden" value={@current_user.id} />
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :url}} type="text" label="Url" />
        <.input field={{f, :type}} type="select" label="Type" options={Bookmark.types()} />
        <.input field={{f, :favorite}} type="checkbox" label="Favorite" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bookmark</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bookmark: bookmark} = assigns, socket) do
    changeset = Bookmarks.change_bookmark(bookmark)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bookmark" => bookmark_params}, socket) do
    changeset =
      socket.assigns.bookmark
      |> Bookmarks.change_bookmark(bookmark_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bookmark" => bookmark_params}, socket) do
    save_bookmark(socket, socket.assigns.action, bookmark_params)
  end

  defp save_bookmark(socket, :edit, bookmark_params) do
    case Bookmarks.update_bookmark(socket.assigns.bookmark, bookmark_params) do
      {:ok, _bookmark} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bookmark updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bookmark(socket, :new, bookmark_params) do
    case Bookmarks.create_bookmark(bookmark_params) do
      {:ok, _bookmark} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bookmark created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
