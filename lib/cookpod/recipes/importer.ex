defmodule Cookpod.Recipes.Importer do
  @moduledoc false

  use Broadway

  alias Broadway.Message
  alias Cookpod.Repo
  alias Cookpod.Recipes.Recipe

  def start_link(_opts \\ []) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092],
             group_id: "group_1",
             topics: ["recipes"]
           ]},
        concurrency: 5
      ],
      processors: [
        default: [
          concurrency: 5
        ]
      ],
      batchers: [
        default: [
          batch_size: 20,
          batch_timeout: 2_000,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(fn data ->
      data
      |> Jason.decode!()
      |> to_recipe_changeset()
    end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
    |> Enum.each(fn e ->
      changeset = e.data

      if changeset.valid? do
        changeset |> Repo.insert()
      end
    end)

    messages
  end

  defp to_recipe_changeset(recipe_json) do
    name = Map.get(recipe_json, "name")
    description = Map.get(recipe_json, "recipeInstructions") |> Enum.join(" ")

    picture_url = Map.get(recipe_json, "image")
    {_, picture} = download_picture(picture_url)

    Recipe.new()
    |> Recipe.changeset(%{
      name: name,
      description: description,
      picture: picture
    })
  end

  defp download_picture(url) do
    download_picture(url, Path.basename(url))
  end

  defp download_picture(_url, "no-photo.png"), do: {:error, nil}

  defp download_picture(url, _) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    extension = Path.extname(url)

    basename =
      url
      |> String.split("/")
      |> :lists.reverse()
      |> List.delete_at(0)
      |> Enum.take(2)
      |> Enum.join("_")

    filename = "#{basename}#{extension}"
    tmp_file = Path.join("/tmp", filename)
    File.write!(tmp_file, body)

    {:ok, %Plug.Upload{filename: filename, path: tmp_file}}
  end
end
