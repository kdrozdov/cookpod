ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cookpod.Repo, :manual)

defmodule Cookpod.Validators.EmailValidatorMock do
  import Ecto.Changeset, only: [validate_change: 3]

  @behaviour Cookpod.Validators.Behaviour

  def call(changeset, field, _opts \\ []) do
    validate_change(changeset, field, fn _, _ ->
      []
    end)
  end
end
