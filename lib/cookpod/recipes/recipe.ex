defmodule Cookpod.Recipes.Recipe do
  @moduledoc false

  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Cookpod.Recipes.Picture.Type

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
