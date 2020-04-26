defmodule CookpodWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CookpodWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Cookpod.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias CookpodWeb.Router.Helpers, as: Routes

      @endpoint CookpodWeb.Endpoint

      import Cookpod.Factory
      import CookpodWeb.TestAuthHelpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cookpod.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Cookpod.Repo, {:shared, self()})
    end

    Mox.stub_with(Cookpod.DnsClientMock, Cookpod.TestDnsClient)

    context = %{conn: Phoenix.ConnTest.build_conn()}

    context =
      case basic_auth_context?(tags) do
        true -> basic_auth_context(context)
        _ -> context
      end

    context =
      case authenticated_user_context?(tags) do
        true -> authenticated_user_context(context)
        _ -> context
      end

    {:ok, context}
  end

  def basic_auth_context?(tags) do
    tags[:basic_auth]
  end

  def basic_auth_context(context) do
    conn =
      Map.fetch!(context, :conn)
      |> CookpodWeb.TestAuthHelpers.basic_auth()

    %{context | conn: conn}
  end

  def authenticated_user_context?(tags) do
    tags[:authenticated_user] && !tags[:guest_user]
  end

  def authenticated_user_context(context) do
    user = insert(:user)

    conn =
      Map.fetch!(context, :conn)
      |> CookpodWeb.TestAuthHelpers.authenticate_user(user)

    Map.merge(context, %{conn: conn, current_user: user})
  end
end
