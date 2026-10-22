# dehydrated

Configure [Dehydrated](https://github.com/dehydrated-io/dehydrated) for Let's Encrypt certificate provisioning via DNS-01 and [Lexicon](https://github.com/AnalogJ/lexicon).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)
- OpenBSD (`cron`)

## Variables

#### dehydrated_domains

```yaml
dehydrated_domains: []
```

Define a list of domains to provision certificates for. One certificate may contain Subject Alternative Names (SAN), where the first Common Name is used as the primary certificate directory name, for example:

```yaml
dehydrated_domains:
  - foo.example.com
  - example.com *.example.com
```

In the example above, two certificates are created:

- `foo.example.com` valid for `foo.example.com`
- `example.com` valid for `example.com` and `*.example.com`

#### dehydrated_group

```yaml
dehydrated_group: "{{ dehydrated_user }}"
```

FreeBSD only. Group to run Dehydrated as and own certificate directories.

#### dehydrated_group_create

```yaml
dehydrated_group_create: true
```

FreeBSD only. Create `dehydrated_group` if it does not exist.

#### dehydrated_group_extra_users

```yaml
dehydrated_group_extra_users:
  - www
```

FreeBSD only. Extra users to add to `dehydrated_group` for read access to certificates.

#### dehydrated_lexicon_config

```yaml
dehydrated_lexicon_config: {}
```

Environment variables passed to Lexicon for DNS-01 challenges. Task output and diffs for the wrapper script are suppressed. See [Lexicon documentation](https://dns-lexicon.readthedocs.io/en/latest/configuration_reference.html). For example:

```yaml
dehydrated_lexicon_config:
  PROVIDER: cloudflare
  LEXICON_CLOUDFLARE_AUTH_TOKEN: secret_token
  LEXICON_CLOUDFLARE_ZONE_ID: zone_id
```

#### dehydrated_logger

```yaml
dehydrated_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/dehydrated/
```

FreeBSD only. Configure the Dehydrated logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### dehydrated_postcmds

```yaml
dehydrated_postcmds: []
```

Commands to run as root in a POSIX shell after Dehydrated runs. Useful for reloading services that use the certificates:

```yaml
dehydrated_postcmds:
  - s6-svc -h /var/service/nginx
```

#### dehydrated_prefix

```yaml
dehydrated_prefix: /usr/local/etc/dehydrated
```

FreeBSD only. Base directory for Dehydrated configuration and certificates. On OpenBSD, `/etc/dehydrated` is used.

#### dehydrated_python_version

```yaml
dehydrated_python_version: "3.9"
```

FreeBSD only. Python version prefix used when installing `dns-lexicon` and `dnspython` packages from pkg.

#### dehydrated_staging

```yaml
dehydrated_staging: true
```

Use the [Let's Encrypt staging environment](https://letsencrypt.org/docs/staging-environment/) instead of production.

#### dehydrated_user

```yaml
dehydrated_user: "dehydrated"
```

FreeBSD only. User to run Dehydrated as. On OpenBSD, `_dehydrated` is used.

#### dehydrated_user_create

```yaml
dehydrated_user_create: true
```

FreeBSD only. Create `dehydrated_user` if it does not exist.
