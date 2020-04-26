defmodule Cookpod.TestDnsClient do
  @moduledoc false
  @behaviour Cookpod.Utils.DnsResolver

  def lookup(_, _, _), do: [true]
end
