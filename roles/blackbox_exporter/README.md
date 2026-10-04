# blackbox_exporter

Install and configure Blackbox Exporter for endpoint probes.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

`blackbox_exporter_listen_address` defaults to `127.0.0.1:9115`.
`blackbox_exporter_modules` supplies the probe modules. The default
`http_2xx` module uses HTTP GET with a ten-second timeout and TLS
certificate verification.

The executable validates the probe configuration before replacement.
Keep the listener private. Probe requests can access URLs from the host.
