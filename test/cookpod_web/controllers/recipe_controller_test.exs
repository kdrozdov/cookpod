defmodule CookpodWeb.RecipeControllerTest do
  use CookpodWeb.ConnCase

  @moduletag basic_auth: true

  @create_attrs params_for(:recipe)
  @invalid_attrs params_for(:recipe, %{name: ""})
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    picture: "some updated picture"
  }

  describe "index" do
    setup [:create_recipe]

    test "lists all recipes", %{conn: conn, recipe: recipe} do
      conn = get(conn, Routes.recipe_path(conn, :index))

      assert html_response(conn, 200) =~ recipe.name
    end
  end

  describe "new recipe" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :new))

      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), recipe: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.recipe_path(conn, :show, id)

      conn = get(conn, Routes.recipe_path(conn, :show, id))
      name = Map.fetch!(@create_attrs, :name)
      assert html_response(conn, 200) =~ name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), recipe: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    setup [:create_recipe]

    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn = get(conn, Routes.recipe_path(conn, :edit, recipe))

      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @update_attrs)

      assert redirected_to(conn) == Routes.recipe_path(conn, :show, recipe)

      conn = get(conn, Routes.recipe_path(conn, :show, recipe))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "publish recipe" do
    test "redirects to recipes list", %{conn: conn} do
      recipe = insert(:recipe, %{state: "draft"})
      conn = put(conn, Routes.recipe_publish_path(conn, :publish, recipe))

      assert redirected_to(conn) == Routes.recipe_path(conn, :index)
    end
  end

  describe "unpublish recipe" do
    test "redirects to drafts list", %{conn: conn} do
      recipe = insert(:recipe, %{state: "published"})

      conn = put(conn, Routes.recipe_unpublish_path(conn, :unpublish, recipe))

      assert redirected_to(conn) == Routes.recipe_path(conn, :drafts)
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))

      assert redirected_to(conn) == Routes.recipe_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_path(conn, :show, recipe))
      end
    end
  end

  defp create_recipe(_) do
    recipe = insert(:recipe)
    {:ok, recipe: recipe}
  end
end
