# dnsmasq

Configure [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) as a forwarding DNS resolver with optional split-horizon host records.

## Supported platforms

- FreeBSD
- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### dnsmasq_host_records

```yaml
dnsmasq_host_records: []
```

Extra `host-record` entries. Each entry returns a fixed address for a name:

```yaml
dnsmasq_host_records:
  - name: web.example.com
    address: 192.0.2.10
```

#### dnsmasq_listen_address

```yaml
dnsmasq_listen_address: "127.0.0.1"
```

Address dnsmasq binds and answers on.

#### dnsmasq_logger

```yaml
dnsmasq_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/dnsmasq/
```

FreeBSD only. Configure the dnsmasq logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### dnsmasq_upstream_servers

```yaml
dnsmasq_upstream_servers:
  - 1.1.1.1
  - 1.0.0.1
```

Recursive servers dnsmasq forwards to. `/etc/resolv.conf` is ignored.
