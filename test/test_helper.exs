ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cookpod.Repo, :manual)

Mox.defmock(Cookpod.DnsClientMock, for: Cookpod.Utils.DnsClientBehaviour)
