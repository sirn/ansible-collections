# node_exporter

Install and configure [Node Exporter](https://github.com/prometheus/node_exporter) for host metrics with its default collectors.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### node_exporter_listen_address

```yaml
node_exporter_listen_address: 127.0.0.1:9100
```

Address and port for the exporter HTTP listener.

#### node_exporter_logger

```yaml
node_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/node_exporter/
```

Configure the Node Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### node_exporter_user

```yaml
node_exporter_user: nobody
```

OS user to run the exporter as.
