defmodule Cookpod.Validators.EmailValidator do
  import Ecto.Changeset, only: [validate_change: 3]

  @behaviour Cookpod.Validators.Behaviour

  def call(changeset, field, options \\ []) do
    mx_fetcher = options[:mx_fetcher] || &default_mx_fetcher/1

    validate_change(changeset, field, fn _, email ->
      mx_validation =
        email
        |> get_domain()
        |> validate_mx(mx_fetcher)

      case mx_validation do
        {:ok, _} -> []
        {:error, error} -> [{field, options[:message] || error}]
      end
    end)
  end

  defp validate_mx(domain, mx_fetcher) do
    mx_records = mx_fetcher.(domain)

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

  defp default_mx_fetcher(domain) do
    domain_charlist = String.to_charlist(domain)
    :inet_res.lookup(domain_charlist, :in, :mx)
  end
end
