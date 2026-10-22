# redis

Configure [Redis](https://redis.io/).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### redis_addresses

```yaml
redis_addresses:
  - 127.0.0.1
```

List of IP addresses for Redis to bind to (`bind`).

#### redis_databases

```yaml
redis_databases: 16
```

Number of databases available (`databases`).

#### redis_logger

```yaml
redis_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/redis/
```

Configure the Redis logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### redis_max_memory

```yaml
redis_max_memory:
```

Maximum memory Redis may use (`maxmemory`), for example `64m`.

#### redis_max_memory_policy

```yaml
redis_max_memory_policy:
```

Eviction policy when `redis_max_memory` is reached (`maxmemory-policy`), for example `allkeys-lru`.

#### redis_port

```yaml
redis_port: 6379
```

TCP port to listen on (`port`).

#### redis_requirepass

```yaml
redis_requirepass:
```

Password required before processing client commands (`requirepass`).

#### redis_snapshot_dir

```yaml
redis_snapshot_dir: /var/db/redis
```

Directory where RDB snapshots are written (`dir`).

#### redis_snapshot_filename

```yaml
redis_snapshot_filename: dump.rdb
```

Filename for the RDB snapshot (`dbfilename`).

#### redis_snapshotting

```yaml
redis_snapshotting:
  - { after: 900, changes: 1 }
  - { after: 300, changes: 10 }
  - { after: 60, changes: 10000 }
```

RDB persistence save points (`save <after> <changes>`):

- `after` — number of seconds since the last snapshot
- `changes` — minimum number of key changes required to trigger a save

#### redis_tls

```yaml
redis_tls: false
```

Enable TLS listener configuration in `redis.conf`.

#### redis_tls_auth

```yaml
redis_tls_auth: false
```

Require client certificate authentication (`tls-auth-clients yes`) when `redis_tls` is `true`.

#### redis_tls_auth_cacert_file

```yaml
redis_tls_auth_cacert_file:
```

CA certificate file path (`tls-ca-cert-file`) used to verify client certificates when `redis_tls_auth` is `true`.

#### redis_tls_cert_file

```yaml
redis_tls_cert_file:
```

Server TLS certificate file path (`tls-cert-file`) when `redis_tls` is `true`.

#### redis_tls_key_file

```yaml
redis_tls_key_file:
```

Server TLS private key file path (`tls-key-file`) when `redis_tls` is `true`.

#### redis_tls_port

```yaml
redis_tls_port: 0
```

TLS listen port (`tls-port`) when `redis_tls` is `true`.

#### redis_unix_socket

```yaml
redis_unix_socket:
```

Optional Unix socket path (`unixsocket`).

#### redis_unix_socket_perm

```yaml
redis_unix_socket_perm: 777
```

Permissions for the Redis Unix socket (`unixsocketperm`).
