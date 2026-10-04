# nginx_exporter

Install and configure nginx Prometheus Exporter for stub-status metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

`nginx_exporter_listen_address` defaults to `127.0.0.1:9113`.
`nginx_exporter_scrape_uri` defaults to `http://127.0.0.1:8181/stub_status`.

Configure an nginx stub-status endpoint. The `nginx` role supplies a
loopback endpoint when `nginx_stub_status: true` is set.
Its address defaults to `nginx_stub_status_address: 127.0.0.1:8181`.
