defmodule Cookpod.Validators.EmailValidator do
  @moduledoc """
  Validator checks mx records for the email domain. It returns an error
  if no mx records are found
  """

  alias Cookpod.Utils.DnsResolver

  def call(email) do
    email
    |> parse_email()
    |> validate_mx()
  end

  defp validate_mx({:ok, %{email: email, domain: domain}}) do
    mx_records = DnsResolver.mx_records(domain)

    case length(mx_records) do
      0 -> {:error, "Email domain does not have any mx records"}
      _ -> {:ok, email}
    end
  end

  defp validate_mx({:error, reason}), do: {:error, reason}

  defp parse_email(email) do
    email_parts = String.split(email, "@")

    case length(email_parts) do
      2 ->
        domain = hd(:lists.reverse(email_parts))
        result = %{email: email, domain: domain}
        {:ok, result}

      _ ->
        {:error, "Can't parse email"}
    end
  end
end
