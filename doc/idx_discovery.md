Cấu hình trong server.conf

Master Indexer:

[indexer_discovery]
pass4SymmKey =

Forwarders:

[indexer_discovery:master]
pass4SymmKey =
master_uri = https://172.17.0.2:8089

[tcpout:group1]
indexerDiscovery = master
