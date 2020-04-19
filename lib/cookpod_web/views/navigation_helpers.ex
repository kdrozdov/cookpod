defmodule CookpodWeb.NavigationHelpers do
  @moduledoc """
  This module contains navigation helpers
  """

  def previous_path(conn, opts \\ []) do
    NavigationHistory.last_path(conn, 1, opts)
  end
end
