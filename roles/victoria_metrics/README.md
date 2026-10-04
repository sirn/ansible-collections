# victoria_metrics

Install and configure single-node VictoriaMetrics for metrics storage.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

- `victoria_metrics_listen_address`: `127.0.0.1:8428`.
- `victoria_metrics_data_dir`: `/var/db/victoria-metrics`.
- `victoria_metrics_retention`: `1y`.
- `victoria_metrics_memory_allowed_bytes`: `1GiB` cache budget, not a
  process memory limit.
- `victoria_metrics_dataset`: empty for directory storage.

Set the listener to a private address for remote agents. Restrict access
with the host firewall. The API has no authentication configured by this role.

An optional ZFS dataset uses zstd compression at `victoria_metrics_data_dir`.
Its parent must exist and contain that path. A parent with `canmount=off`
is supported. The data path must be a directory, not a symlink.
Dataset creation requires an empty data directory. An existing dataset
must be mounted at the configured data path. The role does not move data.
