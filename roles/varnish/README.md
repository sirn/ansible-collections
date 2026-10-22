# varnish

Configure [Varnish Cache](https://varnish-cache.org/).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### varnish_addresses

```yaml
varnish_addresses:
  - 127.0.0.1:8080
  - 127.0.0.1:8081,PROXY
```

Configure Varnish client listen addresses (`varnishd -a`). See [Varnish documentation](https://varnish-cache.org/docs/7.2/reference/varnishd.html).

#### varnish_builtin_vcl

```yaml
varnish_builtin_vcl: true
```

Enable built-in VCL rules in `main.vcl`:

- Set `X-Forwarded-For` to the client's IP address or Cloudflare's `CF-Connecting-IP` (when `varnish_cloudflare` is `true`)
- Set `X-Forwarded-Proto` to `http` or `https`
- Redirect HTTP requests to HTTPS

`X-Forwarded-Proto` is set to `https` when a named listen address in `varnish_addresses` starts with `https`, for example:

```yaml
varnish_addresses:
  - http=127.0.0.1:8080
  - https=127.0.0.1:8081,PROXY
```

#### varnish_cli_addresses

```yaml
varnish_cli_addresses:
  - 127.0.0.1:4121
```

Configure Varnish management interface addresses (`varnishd -T`).

#### varnish_cloudflare

```yaml
varnish_cloudflare: false
```

Trust `CF-Connecting-IP` from client connections originating from Cloudflare IP ranges:

- [Cloudflare IPv4](https://www.cloudflare.com/ips-v4)
- [Cloudflare IPv6](https://www.cloudflare.com/ips-v6)

#### varnish_flags

```yaml
varnish_flags:
  - -p feature=+http2
```

Extra command-line flags passed to `varnishd`.

#### varnish_labels

```yaml
varnish_labels: []
```

Configure VCL labels and templates initialized via the Varnish CLI command file (`boot`). Labels are matched in order via `if (req.http.host ~ match)`:

- `label` — VCL label name
- `match` — regular expression matching `req.http.host`
- `template` — Jinja2 VCL template file path

Example:

```yaml
varnish_labels:
  - label: example
    match: '^example\.com$'
    template: example.vcl.j2
  - label: example_files
    match: '^files\.example\.com$'
    template: example_files.vcl.j2
```

#### varnish_logger

```yaml
varnish_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/varnishd/
```

Configure the `varnishd` logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### varnish_ncsa_format

```yaml
varnish_ncsa_format: >-
  {"time":"%{sec}t.%{msec_frac}t","message":"%m %U","method":"%m",
  "vhost":"%{Host}i","path":"%U","status":"%s","bytes":"%b",
  "duration_us":"%D","cache":"%{Varnish:handling}x"}
```

Log format passed to `varnishncsa -c -j -F`. Quote fields that can be absent and do not log client addresses or query strings. Set an empty string to use `varnishncsa`'s native format.

#### varnish_ncsa_logger

```yaml
varnish_ncsa_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/varnishncsa/
```

Configure the `varnishncsa` access log service logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### varnish_prefix

```yaml
varnish_prefix: /var/varnish
```

Working directory for Varnish. Varnish instance data is stored in `{{ varnish_prefix }}/data/{{ ansible_hostname }}`.

#### varnish_size

```yaml
varnish_size: 1024M
```

Cache storage `malloc` size passed to `varnishd -s`.

#### varnish_version

```yaml
varnish_version: 7
```

Varnish major version package suffix to install from pkg (`varnish<version>`).
