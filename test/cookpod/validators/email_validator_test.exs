defmodule Cookpod.Validators.EmailValidatorTest do
  use Cookpod.DataCase

  import Mox
  import Ecto.Changeset

  test "call/3 when domain has mx records" do
    Cookpod.DnsClientMock
    |> expect(:lookup, fn _, _, _ -> [true] end)

    email = "1@gmail.com"

    result = Cookpod.Validators.EmailValidator.call(email)
    assert {:ok, email} = result
  end

  test "call/3 when domain does not have mx records" do
    Cookpod.DnsClientMock
    |> expect(:lookup, fn _, _, _ -> [] end)

    result = Cookpod.Validators.EmailValidator.call("1@gmail.com")
    assert {:error, "Email domain does not have any mx records"} = result
  end

  test "call/3 when email has invalid format" do
    Cookpod.DnsClientMock
    |> expect(:lookup, fn _, _, _ -> [] end)

    result = Cookpod.Validators.EmailValidator.call("gmail.com")
    assert {:error, "Can't parse email"} = result
  end
end
