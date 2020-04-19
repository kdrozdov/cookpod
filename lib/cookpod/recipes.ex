defmodule Cookpod.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query

  alias Cookpod.Repo
  alias Cookpod.Recipes.Recipe
  alias Cookpod.Recipes.RecipeFsm

  def list_recipes do
    Recipe
    |> where(state: ^RecipeFsm.state(:published))
    |> Repo.all()
  end

  def list_drafts do
    Recipe
    |> where(state: ^RecipeFsm.state(:draft))
    |> Repo.all()
  end

  def get_recipe!(id), do: Repo.get!(Recipe, id)

  def publish_recipe(recipe), do: RecipeFsm.event(recipe, :publish)
  def unpublish_recipe(recipe), do: RecipeFsm.event(recipe, :unpublish)

  def create_recipe(attrs \\ %{}) do
    %Recipe{state: RecipeFsm.initial_state()}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end
end
