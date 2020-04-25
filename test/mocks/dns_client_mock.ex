defmodule Cookpod.DnsClientMock do
  @moduledoc false
  @behaviour Cookpod.Utils.DnsClientBehaviour

  def lookup(_, _, _), do: [true]
end
