defmodule CookpodWeb.RecipeView do
  use CookpodWeb, :view

  def picture_url(recipe, version \\ :original) do
    case recipe.picture do
      nil -> ""
      _ -> Cookpod.Recipes.Picture.url({recipe.picture.file_name, recipe}, version)
    end
  end

  def published?(recipe) do
    recipe.state == "published"
  end
end
