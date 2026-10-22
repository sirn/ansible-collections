# mrtg

Configure [MRTG](https://oss.oetiker.ch/mrtg/) network traffic monitoring.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### mrtg_group

```yaml
mrtg_group: "{{ mrtg_user }}"
```

Group that owns MRTG configuration and working directories.

#### mrtg_group_create

```yaml
mrtg_group_create: false
```

Create `mrtg_group` if it does not exist.

#### mrtg_interval

```yaml
mrtg_interval: 5
```

Interval in minutes between MRTG data collection runs.

#### mrtg_logger

```yaml
mrtg_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/mrtg/
```

Configure the MRTG logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### mrtg_options

```yaml
mrtg_options:
  - growright
```

Global `Options[_]` values written to `mrtg.cfg`.

#### mrtg_refresh

```yaml
mrtg_refresh: 300
```

Browser refresh interval in seconds written to generated HTML pages.

#### mrtg_targets

```yaml
mrtg_targets:
  - name: vtnet0
    target: "`/usr/local/etc/mrtg/mrtg_net.sh vtnet0 link`;"
    fields:
      Title: Network traffic on vtnet0
      MaxBytes: 12500000
      PageTop: <h1>Network traffic on vtnet0</h1>
```

List of monitored targets:

- `name` — target identifier used in `Target[<name>]`
- `target` — MRTG target expression
- `fields` — dictionary of additional MRTG target directives (for example `Title`, `MaxBytes`, `PageTop`)

#### mrtg_user

```yaml
mrtg_user: mrtg
```

OS user to run MRTG as.

#### mrtg_user_create

```yaml
mrtg_user_create: false
```

Create `mrtg_user` if it does not exist.

#### mrtg_workdir

```yaml
mrtg_workdir: /var/www/mrtg
```

Directory where MRTG writes generated HTML pages, graphs, and log files.
