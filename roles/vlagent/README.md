# vlagent

Install and configure [`vlagent`](https://docs.victoriametrics.com/victorialogs/vlagent/) for file collection and queued log delivery.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`) on AMD64 and ARM64

## Variables

#### vlagent_architecture

```yaml
vlagent_architecture: "{{ {'x86_64': 'amd64', 'aarch64': 'arm64'}.get(ansible_architecture, ansible_architecture) }}"
```

Target Go architecture (`amd64` or `arm64`).

#### vlagent_binary_src

```yaml
vlagent_binary_src: "/var/cache/vlagent/vlagent-v{{ vlagent_version }}-freebsd-{{ vlagent_architecture }}"
```

Path on the host where the compiled `vlagent` binary is cached. When absent, the role installs `go127`, `gmake`, and `gtar` from pkg and builds `vlagent` on the host. Check mode reports missing builds without compiling or changing the host.

#### vlagent_build_dir

```yaml
vlagent_build_dir: "/var/cache/vlagent-v{{ vlagent_version }}-freebsd-{{ vlagent_architecture }}"
```

Directory on the host used to extract and compile the `vlagent` source archive.

#### vlagent_data_dir

```yaml
vlagent_data_dir: /var/db/vlagent
```

Directory where persistent remote-write queues and file checkpoints are stored. Keep queues and checkpoints across restarts. Abrupt stops can replay rows, and source files deleted before collection cannot be recovered.

#### vlagent_extra_fields

```yaml
vlagent_extra_fields: {}
```

Dictionary of static key-value fields added to collected log entries. Set stable `host` and `job` fields here.

#### vlagent_file_glob

```yaml
vlagent_file_glob: ""
```

Required. Glob pattern of JSON log files readable by `vlagent_user`. Do not include an s6 timestamp prefix or compressed files. Select current files, not all rotated files, to avoid replaying old logs.

#### vlagent_listen_address

```yaml
vlagent_listen_address: 127.0.0.1:9429
```

Address and port for the `vlagent` HTTP listener.

#### vlagent_logger

```yaml
vlagent_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t /var/log/vlagent/
```

Configure the `vlagent` service logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### vlagent_max_disk_usage_per_url

```yaml
vlagent_max_disk_usage_per_url: 1GiB
```

Maximum disk space for the persistent queue per remote-write URL (`-remoteWrite.maxDiskUsagePerURL`). Old blocks can be dropped at this limit.

#### vlagent_memory_allowed_bytes

```yaml
vlagent_memory_allowed_bytes: 128MiB
```

Cache budget passed to `-memory.allowedBytes` (not a process memory limit).

#### vlagent_msg_field

```yaml
vlagent_msg_field: message
```

JSON field name mapped to the VictoriaLogs `_msg` field.

#### vlagent_remote_write_url

```yaml
vlagent_remote_write_url: ""
```

Required. VictoriaLogs `/insert/native` remote-write endpoint URL (`-remoteWrite.url`).

#### vlagent_source_sha256

```yaml
vlagent_source_sha256: 9dab43bfb2ccc2b3009a2e7cacd798f12b561a92f4a29c8a697c60295a383874
```

SHA-256 checksum for the upstream VictoriaLogs source archive.

#### vlagent_source_url

```yaml
vlagent_source_url: "https://codeload.github.com/VictoriaMetrics/VictoriaLogs/tar.gz/refs/tags/v{{ vlagent_version }}"
```

Download URL for the VictoriaLogs source archive.

#### vlagent_stream_fields

```yaml
vlagent_stream_fields: [host, job]
```

List of fields used to form VictoriaLogs log streams. Do not use high-cardinality fields such as file paths or client addresses.

#### vlagent_time_field

```yaml
vlagent_time_field: time
```

JSON field name mapped to the VictoriaLogs `_time` field.

#### vlagent_user

```yaml
vlagent_user: vlagent
```

OS user created to run `vlagent`.

#### vlagent_version

```yaml
vlagent_version: 1.53.0
```

VictoriaLogs release version to build `vlagent` from. Update `vlagent_source_sha256` when changing the version.
