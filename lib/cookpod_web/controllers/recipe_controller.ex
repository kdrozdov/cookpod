defmodule CookpodWeb.RecipeController do
  use CookpodWeb, :controller

  alias Cookpod.Recipes
  alias Cookpod.Recipes.Recipe

  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def drafts(conn, _params) do
    recipes = Recipes.list_drafts()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def publish(conn, %{"recipe_id" => id}) do
    recipe = Recipes.get_recipe!(id)

    case Recipes.publish_recipe(recipe) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Recipe was published.")
        |> redirect(to: Routes.recipe_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Recipe was not published.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))
    end
  end

  def unpublish(conn, %{"recipe_id" => id}) do
    recipe = Recipes.get_recipe!(id)

    case Recipes.unpublish_recipe(recipe) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Recipe was unpublished.")
        |> redirect(to: Routes.recipe_path(conn, :drafts))

      {:error, _} ->
        conn
        |> put_flash(:error, "Recipe was not unpublished.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    nutrients = Recipes.recipe_nutrients(recipe)
    Recipes.increment_recipe_views(id)
    render(conn, "show.html", recipe: recipe, nutrients: nutrients)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    changeset = Recipes.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(id)

    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end

  def view_stats(conn, _params) do
    stats_stream = Recipes.view_stats_stream()
    render(conn, "view_stats.html", stats_stream: stats_stream)
  end
end
