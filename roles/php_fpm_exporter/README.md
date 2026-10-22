# php_fpm_exporter

Install and configure [PHP-FPM Exporter](https://github.com/hipages/php-fpm_exporter) for pool metrics.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### php_fpm_exporter_listen_address

```yaml
php_fpm_exporter_listen_address: 127.0.0.1:9253
```

Address and port for the exporter HTTP listener.

#### php_fpm_exporter_logger

```yaml
php_fpm_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/php-fpm_exporter/
```

Configure the PHP-FPM Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### php_fpm_exporter_scrape_uri

```yaml
php_fpm_exporter_scrape_uri: unix:///var/run/php-fpm/php-fpm.sock;/status
```

FastCGI URI used to read PHP-FPM pool status. Set `pm.status_path = /status` in the PHP-FPM pool, for example through `php_fpm_config` in [`php`](../php/README.md). Do not expose the status path through the public web server.

#### php_fpm_exporter_user

```yaml
php_fpm_exporter_user: www
```

OS user to run the exporter as.
