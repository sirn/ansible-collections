# victoria_metrics

Install and configure single-node [VictoriaMetrics](https://docs.victoriametrics.com/) for metrics storage.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### victoria_metrics_data_dir

```yaml
victoria_metrics_data_dir: /var/db/victoria-metrics
```

Directory where VictoriaMetrics stores time-series data (`-storageDataPath`).

#### victoria_metrics_dataset

```yaml
victoria_metrics_dataset: ""
```

Optional ZFS dataset name mounted at `victoria_metrics_data_dir` with `zstd` compression. Leave empty for standard directory storage. Its parent must exist and contain that path (a parent with `canmount=off` is supported). The data path must be an empty directory (or already mounted at that dataset) and not a symlink. The role does not move existing data.

#### victoria_metrics_listen_address

```yaml
victoria_metrics_listen_address: 127.0.0.1:8428
```

Address and port for the VictoriaMetrics HTTP listener (`-httpListenAddr`). Set the listener to a private address for remote agents and restrict access with the host firewall. The API has no authentication configured by this role.

#### victoria_metrics_logger

```yaml
victoria_metrics_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/victoria-metrics/
```

Configure the VictoriaMetrics logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### victoria_metrics_memory_allowed_bytes

```yaml
victoria_metrics_memory_allowed_bytes: 1GiB
```

Cache budget passed to `-memory.allowedBytes` (not a process memory limit).

#### victoria_metrics_retention

```yaml
victoria_metrics_retention: 1y
```

Metrics retention period passed to `-retentionPeriod`.

#### victoria_metrics_user

```yaml
victoria_metrics_user: victoria-metrics
```

OS user to run VictoriaMetrics as.
