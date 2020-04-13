defmodule CookpodWeb.AuthHelpers do
  @moduledoc """
  This module contains auth helpers
  """

  def authenticated?(conn) do
    case conn.assigns[:current_user] do
      nil -> false
      _ -> true
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end
end
