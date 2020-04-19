defmodule Cookpod.Recipes.RecipeFsm do
  @moduledoc false

  @initial_state "draft"
  @states %{
    published: "published",
    draft: "draft"
  }

  alias Cookpod.Recipes.Recipe
  alias Cookpod.Recipes

  def initial_state, do: @initial_state
  def states, do: @states
  def state(name), do: Map.fetch!(@states, name)

  # Events
  def event(%Recipe{state: "draft"} = recipe, :publish) do
    publish(recipe)
  end

  def event(%Recipe{state: "published"} = recipe, :unpublish) do
    unpublish(recipe)
  end

  # Handlers
  def publish(recipe) do
    Recipes.update_recipe(recipe, %{state: state(:published)})
  end

  def unpublish(recipe) do
    Recipes.update_recipe(recipe, %{state: state(:draft)})
  end
end
