# node_exporter

Install and configure Node Exporter for host metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

`node_exporter_listen_address` defaults to `127.0.0.1:9100`.
`node_exporter_user` defaults to `nobody`.
The role runs the exporter with its default collectors.
