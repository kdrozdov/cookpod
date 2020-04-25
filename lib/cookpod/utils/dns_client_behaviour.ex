defmodule Cookpod.Utils.DnsClientBehaviour do
  @moduledoc false
  @callback lookup(charlist(), atom(), atom()) :: []
end
