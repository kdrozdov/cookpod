defmodule CookpodWeb.RecipeView do
  use CookpodWeb, :view

  def picture_url(recipe, version \\ :original) do
    Cookpod.Recipes.Picture.url(recipe.picture, version)
  end

  def published?(recipe) do
    recipe.state == "published"
  end
end
