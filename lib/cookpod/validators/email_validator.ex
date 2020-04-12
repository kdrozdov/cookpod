defmodule Cookpod.Validators.EmailValidator do
  import Ecto.Changeset, only: [validate_change: 3]

  def call(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, email ->
      mx_validation =
        email
        |> get_domain()
        |> validate_mx()

      case mx_validation do
        {:ok, _} -> []
        {:error, error} -> [{field, options[:message] || error}]
      end
    end)
  end

  defp validate_mx(domain) do
    domain_charlist = String.to_charlist(domain)
    mx_records = :inet_res.lookup(domain_charlist, :in, :mx)

    case length(mx_records) do
      0 -> {:error, "Invalid domain"}
      _ -> {:ok, domain}
    end
  end

  defp get_domain(email) do
    email_parts = String.split(email, "@")

    case length(email_parts) do
      2 -> hd(:lists.reverse(email_parts))
      _ -> nil
    end
  end
end
