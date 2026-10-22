# blackbox_exporter

Install and configure [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter) for endpoint probes.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### blackbox_exporter_listen_address

```yaml
blackbox_exporter_listen_address: 127.0.0.1:9115
```

Address and port for the exporter HTTP listener. Keep the listener private because probe requests can access URLs from the host.

#### blackbox_exporter_logger

```yaml
blackbox_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/blackbox_exporter/
```

Configure the Blackbox Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### blackbox_exporter_modules

```yaml
blackbox_exporter_modules:
  http_2xx:
    prober: http
    timeout: 10s
    http:
      method: GET
      tls_config:
        insecure_skip_verify: false
```

Probe module definitions written to `/usr/local/etc/blackbox_exporter.yml`. The executable validates the configuration before replacement.

#### blackbox_exporter_user

```yaml
blackbox_exporter_user: prometheus
```

OS user to run the exporter as.
