# victoria_logs

Install and configure single-node [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/) for log storage.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### victoria_logs_data_dir

```yaml
victoria_logs_data_dir: /var/db/victoria-logs
```

Directory where VictoriaLogs stores log partitions.

#### victoria_logs_dataset

```yaml
victoria_logs_dataset: ""
```

Optional ZFS dataset name mounted at `victoria_logs_data_dir` with `zstd` compression. Leave empty for standard directory storage. Its parent must exist and contain that path (a parent with `canmount=off` is supported). The data path must be an empty directory (or already mounted at that dataset) and not a symlink. The role does not move existing data.

#### victoria_logs_listen_address

```yaml
victoria_logs_listen_address: 127.0.0.1:9428
```

Address and port for the VictoriaLogs HTTP listener. Do not expose the listener on a public network.

#### victoria_logs_logger

```yaml
victoria_logs_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t /var/log/victoria-logs/
```

Configure the VictoriaLogs service logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### victoria_logs_max_disk_usage

```yaml
victoria_logs_max_disk_usage: 4GiB
```

Storage target passed to `-retention.maxDiskSpaceUsageBytes` (not a hard filesystem quota).

#### victoria_logs_memory_allowed_bytes

```yaml
victoria_logs_memory_allowed_bytes: 256MiB
```

Cache budget passed to `-memory.allowedBytes` (not a process memory limit).

#### victoria_logs_min_free_disk_space

```yaml
victoria_logs_min_free_disk_space: 2GiB
```

Free-space reserve passed to `-storage.minFreeDiskSpaceBytes`.

#### victoria_logs_retention

```yaml
victoria_logs_retention: 90d
```

Log retention period passed to `-retentionPeriod`. Retention removes daily partitions.

#### victoria_logs_user

```yaml
victoria_logs_user: victoria-logs
```

OS user to run VictoriaLogs as.
