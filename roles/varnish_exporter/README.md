# varnish_exporter

Install and configure Varnish Exporter for cache metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

`varnish_exporter_listen_address` defaults to `127.0.0.1:9131`.
`varnish_exporter_instance` defaults to
`{{ varnish_prefix }}/data/{{ ansible_hostname }}`.

The exporter runs as `varnish` and reads counters with
`/usr/local/bin/varnishstat`. That user needs access to the instance's
shared-memory counters.
