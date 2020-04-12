defmodule Cookpod.Validators.Behaviour do
  @moduledoc """
  Describes validator behaviour
  """

  @callback call(
              Ecto.Changeset.t(),
              atom(),
              (atom(), term() ->
                 [{atom(), String.t()} | {atom(), {String.t(), Keyword.t()}}])
            ) :: Ecto.Changeset.t()
end
