defmodule Mybookmarks.Bookmarks.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  @types [:blog, :read_it_later, :learning, :other]
  @fields [:name, :url, :type, :favorite, :user_id]
  @required_fields @fields

  schema "bookmarks" do
    field :favorite, :boolean, default: false
    field :name, :string
    field :type, Ecto.Enum, values: @types
    field :url, :string
    belongs_to :user, Mybookmarks.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def types do
    @types
  end
end
