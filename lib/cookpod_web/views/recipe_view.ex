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

  def product_selector_options() do
    Cookpod.Recipes.list_products()
    |> Enum.map(&{&1.name, &1.id})
  end
end
