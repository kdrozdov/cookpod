defmodule Cookpod.Recipes.RecipeFsm do
  @moduledoc false

  @initial_state "draft"
  @states %{
    published: "published",
    draft: "draft"
  }

  alias Cookpod.Recipes.Recipe
  alias Cookpod.Recipes.RecipeQueries

  def initial_state, do: @initial_state
  def states, do: Map.values(@states)

  # Events
  def event(%Recipe{state: "draft"} = recipe, :publish) do
    publish(recipe)
  end

  def event(%Recipe{state: "published"} = recipe, :unpublish) do
    unpublish(recipe)
  end

  # Handlers
  def publish(recipe) do
    {:ok, next_state} = Map.fetch(@states, :published)
    RecipeQueries.update(recipe, %{state: next_state})
  end

  def unpublish(recipe) do
    {:ok, next_state} = Map.fetch(@states, :draft)
    RecipeQueries.update(recipe, %{state: next_state})
  end
end
