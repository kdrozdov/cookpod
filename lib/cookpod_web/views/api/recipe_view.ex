defmodule CookpodWeb.Api.RecipeView do
  use CookpodWeb, :view

  def render("index.json", %{recipes: recipes}) do
    %{recipes: render_many(recipes, __MODULE__, "recipe.json")}
  end

  def render("show.json", %{recipe: recipe}) do
    %{recipe: render_one(recipe, __MODULE__, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      picture: Cookpod.Recipes.Picture.url({recipe.picture.file_name, recipe})
    }
  end

end
