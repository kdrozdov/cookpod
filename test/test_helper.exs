{:ok, _} = Application.ensure_all_started(:ex_machina)

Application.put_env(:cookpod, :dns_client, Cookpod.DnsClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cookpod.Repo, :manual)

Mox.defmock(Cookpod.DnsClientMock, for: Cookpod.Utils.DnsResolver)
