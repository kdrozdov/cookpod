defmodule Cookpod.Utils.DnsResolver do
  @moduledoc false

  @callback lookup(charlist(), atom(), atom()) :: list()

  def mx_records(domain) do
    domain_charlist = to_charlist(domain)
    client().lookup(domain_charlist, :in, :mx)
  end

  defp client do
    Application.get_env(:cookpod, :dns_client, :inet_res)
  end
end
