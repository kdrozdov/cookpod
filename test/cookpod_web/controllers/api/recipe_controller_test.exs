defmodule CookpodWeb.Api.RecipeControllerTest do
  use CookpodWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias Cookpod.Recipes

  @recipe_attrs %{
    description: "some description",
    name: "some name",
    picture: "test.jpg",
    state: "published"
  }

  def create_recipe(attrs \\ @recipe_attrs) do
    {:ok, recipe} = Recipes.create_recipe(attrs)
    recipe
  end

  describe "index" do
    test "lists all recipes", %{conn: conn, swagger_schema: schema} do
      create_recipe()

      conn
      |> get(Routes.api_recipe_path(conn, :index))
      |> validate_resp_schema(schema, "RecipesResponse")
      |> json_response(200)
    end
  end

  describe "show" do
    test "recipe", %{conn: conn, swagger_schema: schema} do
      recipe = create_recipe()

      conn
      |> get(Routes.api_recipe_path(conn, :show, recipe))
      |> validate_resp_schema(schema, "RecipesResponse")
      |> json_response(200)
    end
  end
end
