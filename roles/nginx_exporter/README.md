# nginx_exporter

Install and configure [nginx Prometheus Exporter](https://github.com/nginx/nginx-prometheus-exporter) for stub-status metrics.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### nginx_exporter_listen_address

```yaml
nginx_exporter_listen_address: 127.0.0.1:9113
```

Address and port for the exporter HTTP listener.

#### nginx_exporter_logger

```yaml
nginx_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/nginx-exporter/
```

Configure the nginx Prometheus Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### nginx_exporter_scrape_uri

```yaml
nginx_exporter_scrape_uri: http://127.0.0.1:8181/stub_status
```

URI of the nginx `stub_status` page to scrape. The [`nginx`](../nginx/README.md) role supplies a loopback endpoint at `127.0.0.1:8181` when `nginx_stub_status: true` is set.

#### nginx_exporter_user

```yaml
nginx_exporter_user: nobody
```

OS user to run the exporter as.
