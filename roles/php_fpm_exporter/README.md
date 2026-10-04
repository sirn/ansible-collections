# php_fpm_exporter

Install and configure PHP-FPM Exporter for pool metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

`php_fpm_exporter_listen_address` defaults to `127.0.0.1:9253`.
`php_fpm_exporter_scrape_uri` defaults to
`unix:///var/run/php-fpm/php-fpm.sock;/status`.
The exporter runs as `www` by default and reads pool status over FastCGI.

Set `pm.status_path = /status` in the PHP-FPM pool, for example through
`php_fpm_config`. The exporter user needs access to the socket.
Do not expose the status path through the public web server.
