# vmagent

Install and configure [`vmagent`](https://docs.victoriametrics.com/vmagent/) for metrics scraping and queued remote write.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### vmagent_data_dir

```yaml
vmagent_data_dir: /var/db/vmagent
```

Directory where the persistent remote-write queue is stored (`-remoteWrite.tmpDataPath`).

#### vmagent_extra_scrape_configs

```yaml
vmagent_extra_scrape_configs: []
```

Additional Prometheus scrape jobs appended to `vmagent_scrape_configs`. Use this list to add optional service targets without replacing the main job list. The same validation and credential protections apply.

#### vmagent_global

```yaml
vmagent_global:
  scrape_interval: 30s
  external_labels:
    host: "{{ ansible_hostname }}"
```

Global Prometheus scrape configuration written to `/usr/local/etc/vmagent.yml`.

#### vmagent_listen_address

```yaml
vmagent_listen_address: 127.0.0.1:8429
```

Address and port for the `vmagent` HTTP listener (`-httpListenAddr`).

#### vmagent_logger

```yaml
vmagent_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/vmagent/
```

Configure the `vmagent` logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### vmagent_max_disk_usage_per_url

```yaml
vmagent_max_disk_usage_per_url: 1GB
```

Maximum disk usage for the persistent queue per remote-write URL (`-remoteWrite.maxDiskUsagePerURL`). The oldest queued samples are dropped when this limit is reached.

#### vmagent_memory_allowed_bytes

```yaml
vmagent_memory_allowed_bytes: 128MiB
```

Cache budget passed to `-memory.allowedBytes` (not a process memory limit).

#### vmagent_remote_write_url

```yaml
vmagent_remote_write_url: ""
```

Required. Remote-write endpoint URL (`-remoteWrite.url`).

#### vmagent_scrape_configs

```yaml
vmagent_scrape_configs: []
```

List of Prometheus `scrape_configs` jobs written to `/usr/local/etc/vmagent.yml` with mode `0600`. The executable validates the scrape configuration before replacement, and task output and diffs are suppressed because scrape jobs can contain credentials.

#### vmagent_user

```yaml
vmagent_user: victoria-metrics
```

OS user to run `vmagent` as.
