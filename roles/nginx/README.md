# nginx

Install and configure nginx sites and stream proxies.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## TLS and status settings

`nginx_ssl_protocols` supplies the protocols for HTTPS sites and TLS stream
proxies. Its default is `TLSv1 TLSv1.1 TLSv1.2 TLSv1.3`.
Set it to `TLSv1.2 TLSv1.3` for sites that do not require older protocols.

`nginx_stub_status` defaults to `false`. When enabled, the role adds a
separate status server at `nginx_stub_status_address`, which defaults to
`127.0.0.1:8181`. Only loopback clients can read `/stub_status`.
All other paths on that server return 404.

The role validates the configuration with `nginx -t` before replacement
and keeps a backup.
