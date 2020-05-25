defmodule Cookpod.Recipes.Picture do
  @moduledoc false

  use Arc.Definition
  use Arc.Ecto.Definition

  @thumb_size 280
  @original_size 600
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @versions [:original, :thumb]

  def __storage, do: Arc.Storage.Local

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  def filename(version, {file, _}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{version}_#{file_name}"
  end

  def transform(:original, _) do
    convert_params = "-strip -resize #{@original_size}x#{@original_size}"
    {:convert, convert_params}
  end

  def transform(:thumb, _) do
    convert_params =
      "-strip -thumbnail #{@thumb_size}x#{@thumb_size}^ -gravity center -extent #{@thumb_size}x#{
        @thumb_size
      }"

    {:convert, convert_params}
  end

  def default_url(_version) do
    "/images/placeholders/recipe.png"
  end

  def try_url(recipe) do
    case recipe.picture do
      nil -> nil
      _ -> url({recipe.picture.file_name, recipe})
    end
  end
end
