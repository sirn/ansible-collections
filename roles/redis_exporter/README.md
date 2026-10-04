# redis_exporter

Install and configure Redis Exporter for Redis metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

- `redis_exporter_listen_address`: `127.0.0.1:9121`.
- `redis_exporter_redis_url`: `redis://127.0.0.1:6379`.
- `redis_exporter_password`: `redis_requirepass` when defined, otherwise empty.

A non-empty password is stored in a JSON file with mode `0600`, not in
command-line arguments. The password-file task suppresses output and diffs.
The role removes that file when no password is configured.
