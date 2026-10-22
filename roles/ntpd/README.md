# ntpd

Configure base `ntpd` and `ntpdate` time synchronization on FreeBSD.

## Supported platforms

- FreeBSD

## Variables

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
