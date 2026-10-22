# openntpd

Configure [OpenNTPD](https://www.openntpd.org/).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)
- OpenBSD

## Variables

#### openntpd_constraints

```yaml
openntpd_constraints:
  - https://www.cloudflare.com/
  - https://www.google.com/
```

List of HTTPS URLs used as time constraints (`constraints from "<url>"`) in `ntpd.conf`.

#### openntpd_force_sync

```yaml
openntpd_force_sync: false
```

Pass `-s` to `ntpd` to set the time immediately at startup.

#### openntpd_logger

```yaml
openntpd_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/openntpd/
```

FreeBSD only. Configure the OpenNTPD logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### openntpd_servers

```yaml
openntpd_servers:
  - pool.ntp.org
```

List of NTP server pools or hostnames (`servers <server>`) in `ntpd.conf`.
