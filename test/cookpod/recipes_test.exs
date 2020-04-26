defmodule Cookpod.RecipesTest do
  use Cookpod.DataCase

  alias Cookpod.Recipes

  describe "recipes" do
    alias Cookpod.Recipes.Recipe

    @valid_attrs %{
      description: "some description",
      name: "some name",
      state: "draft"
    }
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil, picture: nil}

    test "list_recipes/0 returns all published recipes" do
      recipe = insert(:recipe, %{state: "published"})
      assert Recipes.list_recipes() == [recipe]
    end

    test "list_drafts/0 returns all drafts" do
      recipe = insert(:recipe, %{state: "draft"})
      assert Recipes.list_drafts() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = insert(:recipe)
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@valid_attrs)
      assert recipe.description == "some description"
      assert recipe.name == "some name"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert recipe.description == "some updated description"
      assert recipe.name == "some updated name"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = insert(:recipe)
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "publish_recipe/1 changes state to published if recipe is draft" do
      recipe = insert(:recipe, %{state: "draft"})
      assert {:ok, recipe} = Recipes.publish_recipe(recipe)
      assert recipe.state == "published"
    end

    test "unpublish_recipe/1 changes state to draft if recipe is published" do
      recipe = insert(:recipe, %{state: "published"})
      assert {:ok, recipe} = Recipes.unpublish_recipe(recipe)
      assert recipe.state == "draft"
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = insert(:recipe)
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end
end
