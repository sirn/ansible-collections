# victoria_logs

Install and configure single-node VictoriaLogs for log storage.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

- `victoria_logs_listen_address`: `127.0.0.1:9428`.
- `victoria_logs_data_dir`: `/var/db/victoria-logs`.
- `victoria_logs_retention`: `90d`. Retention removes daily partitions.
- `victoria_logs_max_disk_usage`: `4GiB` storage target, not a hard
  filesystem quota.
- `victoria_logs_min_free_disk_space`: `2GiB` free-space reserve.
- `victoria_logs_memory_allowed_bytes`: `256MiB` cache budget, not a
  process memory limit.
- `victoria_logs_dataset`: empty for directory storage.

The role installs `victoria-logs` from pkg and disables its rc service.
Do not expose the listener on a public network.

An optional ZFS dataset uses zstd compression at `victoria_logs_data_dir`.
Its parent must exist and contain that path. A parent with `canmount=off`
is supported. The data path must be a directory, not a symlink.
Dataset creation requires an empty data directory. An existing dataset
must be mounted at the configured data path. The role does not move data.
