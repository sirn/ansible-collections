# ntpd

Configure base `ntpd` and `ntpdate` time synchronization on FreeBSD.

## Supported platforms

- FreeBSD
- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### ntpd_logger

```yaml
ntpd_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/ntpd/
```

FreeBSD with `s6: true` only. Configure the ntpd logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### ntpd_pools

```yaml
ntpd_pools:
  - pool.ntp.org
```

List of NTP pool hostnames written as `pool <hostname> iburst` in `/etc/ntp.conf`.

#### ntpd_servers

```yaml
ntpd_servers:
```

Optional list of NTP server hostnames written as `server <hostname> iburst` in `/etc/ntp.conf`.

#### s6

```yaml
s6: false
```

Supervise ntpd with s6 instead of the rc service. Set `ntpd_logger` to tune logging.
