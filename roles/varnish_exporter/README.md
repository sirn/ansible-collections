# varnish_exporter

Install and configure [Varnish Exporter](https://github.com/jonnenauha/prometheus_varnish_exporter) for cache metrics.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### varnish_exporter_instance

```yaml
varnish_exporter_instance: "{{ varnish_prefix }}/data/{{ ansible_hostname }}"
```

Varnish instance directory passed to `varnishstat -n`.

#### varnish_exporter_listen_address

```yaml
varnish_exporter_listen_address: 127.0.0.1:9131
```

Address and port for the exporter HTTP listener.

#### varnish_exporter_logger

```yaml
varnish_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/varnish_exporter/
```

Configure the Varnish Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### varnish_exporter_user

```yaml
varnish_exporter_user: varnish
```

OS user to run the exporter as. The user reads counters with `/usr/local/bin/varnishstat` and needs access to the instance's shared-memory counters.
