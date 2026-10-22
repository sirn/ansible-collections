# redis_exporter

Install and configure [Redis Exporter](https://github.com/oliver006/redis_exporter) for Redis metrics.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### redis_exporter_listen_address

```yaml
redis_exporter_listen_address: 127.0.0.1:9121
```

Address and port for the exporter HTTP listener.

#### redis_exporter_logger

```yaml
redis_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/redis_exporter/
```

Configure the Redis Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### redis_exporter_password

```yaml
redis_exporter_password: "{{ redis_requirepass | default('', true) }}"
```

Password used to authenticate to Redis. A non-empty password is stored in a JSON file with mode `0600`, not in command-line arguments. The password-file task suppresses output and diffs. The role removes that file when no password is configured.

#### redis_exporter_redis_url

```yaml
redis_exporter_redis_url: redis://127.0.0.1:6379
```

Target Redis URL to scrape.

#### redis_exporter_user

```yaml
redis_exporter_user: nobody
```

OS user to run the exporter as and own the password file.
