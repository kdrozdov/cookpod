defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller
  use PhoenixSwagger

  alias Cookpod.Recipes

  swagger_path :index do
    get "/recipes"
    description "List of recipes"
    response 200, "Success", Schema.ref(:Recipes)
  end

  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  swagger_path :show do
    get "/recipes/{id}"
    description "Recipe"
    parameters do
      id :path, :integer, "Recipe ID", required: true, example: 1
    end
    response 200, "Success", Schema.ref(:Recipe)
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    render(conn, "show.json", recipe: recipe)
  end

  def swagger_definitions do
    %{
      Recipe: swagger_schema do
        title "Recipe"
        properties do
          id :integer, "", required: true
          name :string, "", required: true
          description :string, "", required: true
        end

        example(%{
          id: 1,
          name: "Scrambled eggs",
          description: "Steps to cook scrambled eggs"
        })
      end,
      Recipes: swagger_schema do
        title "Recipes"
        type :array
        items Schema.ref(:Recipe)
      end
    }
  end
end

