# racct

Enable FreeBSD resource accounting (`kern.racct.enable=1`) and configure [`rctl(8)`](https://man.freebsd.org/cgi/man.cgi?query=rctl&sektion=8) rules in `/etc/rctl.conf`.

Enabling `kern.racct.enable` in `/boot/loader.conf` triggers a system reboot.

## Supported platforms

- FreeBSD

## Variables

#### racct_rules

```yaml
racct_rules: []
```

List of resource limit rules written to `/etc/rctl.conf` and reloaded via `service rctl reload`. For example:

```yaml
racct_rules:
  - jail:web:memoryuse:deny=1G
```
