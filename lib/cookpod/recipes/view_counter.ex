defmodule Cookpod.Recipes.ViewCounter do
  use GenServer

  @moduledoc false
  @table_name :recipe_views
  @stats_batch_size 100
  @end_of_table :"$end_of_table"

  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def increment(recipe_id), do: GenServer.cast(__MODULE__, {:increment, recipe_id})

  def stats_stream() do
    Stream.resource(
      &stream_start_fun/0,
      &stream_next_fun/1,
      fn _ -> :ok end
    )
  end

  # GenServer API

  def init(state) do
    :ets.new(@table_name, [:named_table, :set, :protected, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:increment, recipe_id}, _state) do
    recipe_stats = get_recipe_stats(recipe_id)
    new_state = Map.update!(recipe_stats, :views, &(&1 + 1))
    set_recipe_stats(recipe_id, new_state)
    {:noreply, new_state}
  end

  def handle_call(:stats, _from, state), do: {:reply, Map.values(state), state}

  def get_recipe_stats(recipe_id) do
    case :ets.lookup(@table_name, recipe_id) do
      [] -> %{id: recipe_id, views: 0}
      [{_key, stats}] -> stats
    end
  end

  defp set_recipe_stats(recipe_id, stats) do
    :ets.insert(@table_name, {recipe_id, stats})
  end

  defp stream_start_fun() do
    match_spec = [{{:_, :"$1"}, [], [:"$1"]}]
    :ets.select(@table_name, match_spec, @stats_batch_size)
  end

  defp stream_next_fun(acc) do
    case acc do
      @end_of_table ->
        {:halt, acc}

      {list, continuation} ->
        {list, :ets.select(continuation)}
    end
  end
end
