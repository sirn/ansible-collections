# haproxy

Configure [HAProxy](https://www.haproxy.org/). The role validates the configuration with `haproxy -c -f` before replacement and keeps a backup.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### haproxy_backends

```yaml
haproxy_backends: []
```

Only used when `haproxy_template` is set to `default.conf.j2`. Configures HAProxy `backend` blocks:

- `name` — backend name
- `mode` — backend mode (`http` or `tcp`)
- `hostname` — backend server identifier
- `address` — backend server address
- `port` — backend server port (optional)
- `fullconn` — `fullconn` limit for the backend (default: `4000`)
- `options` — list of `option` directives for the backend (optional)
- `resolver` — resolver section name for runtime DNS resolution (optional)
- `flags` — list of server flags (optional)

Example:

```yaml
haproxy_backends:
  - name: prod
    mode: http
    hostname: example-prod
    address: "10.0.10.1"
    port: "8443"
    resolver: mydns
    flags:
      - "ssl verify none"
      - "check fall 3 rise 2"
      - "send-proxy-v2"
```

#### haproxy_extra_config

```yaml
haproxy_extra_config: ""
```

Only used when `haproxy_template` is set to `default.conf.j2`. Additional top-level configuration appended after the generated sections, such as a dedicated SPOE agent backend.

#### haproxy_frontends

```yaml
haproxy_frontends: []
```

Only used when `haproxy_template` is set to `default.conf.j2`. Configures HAProxy `frontend` blocks:

- `name` — frontend name
- `mode` — frontend mode (`http` or `tcp`)
- `binds` — list of frontend bindings:
  - `address` — listen address and port
  - `flags` — list of bind options (optional)
- `config` — free-form configuration lines inserted into the frontend block (optional)
- `http_request` — list of `http-request` rules (optional)
- `default_backend` — fallback backend name (default: `default-http`)
- `backends` — list of backend routing rules:
  - `backend` — backend name to route to
  - `acls` — list of host or SNI ACLs:
    - `acl` — ACL identifier
    - `domain` — domain name to match (`hdr(host)` in `http` mode, `ssl_fc_sni` in `tcp` mode)
    - `mode` — optional HAProxy match mode (`-m <mode>`, for example `dom`)
  - `allowed_sources` — optional list of source IPs or CIDRs to restrict access

Example:

```yaml
haproxy_frontends:
  - name: web
    mode: http
    binds:
      - address: "192.0.2.10:8443"
        flags:
          - "ssl"
          - "crt /usr/local/etc/dehydrated/certs/example.com/fullbundle.pem"
          - "alpn h2,http/1.1"
    backends:
      - backend: prod
        acls:
          - acl: is-prod
            domain: example.com
          - acl: is-dev
            domain: dev.example.com
            mode: dom
```

#### haproxy_logger

```yaml
haproxy_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/haproxy/
```

Configure the HAProxy logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### haproxy_maxconn

```yaml
haproxy_maxconn: 4000
```

Maximum number of concurrent connections in the `global` section.

#### haproxy_prefix

```yaml
haproxy_prefix: /var/haproxy
```

Directory where HAProxy configuration files are stored.

#### haproxy_resolvers

```yaml
haproxy_resolvers: []
```

Only used when `haproxy_template` is set to `default.conf.j2`. Configures `resolvers` sections for runtime DNS resolution:

- `name` — resolver section name
- `nameservers` — list of nameservers:
  - `name` — nameserver identifier
  - `address` — nameserver IP address and port (for example `10.0.0.1:53`)
- `resolve_retries` — number of DNS query retries (optional)
- `timeout_retry` — time between DNS retries (optional)
- `hold_valid` — interval to hold valid DNS answers (optional)

Example:

```yaml
haproxy_resolvers:
  - name: mydns
    nameservers:
      - name: dns1
        address: 10.0.0.1:53
    resolve_retries: 3
    timeout_retry: 1s
    hold_valid: 10s
```

#### haproxy_spoe_configs

```yaml
haproxy_spoe_configs: []
```

List of SPOE message configuration templates installed before HAProxy configuration validation:

- `src` — Jinja2 template path
- `dest` — destination path on the host; the parent directory must exist

Template changes notify the HAProxy restart handler. Configure frontend filters, message routing, and agent backends separately.

#### haproxy_stats

```yaml
haproxy_stats: {}
```

Only used when `haproxy_template` is set to `default.conf.j2`. Configures the HAProxy `stats` frontend:

- `binds` — list of bind objects (`address` and optional `flags`)
- `options` — list of `stats` option strings

#### haproxy_template

```yaml
haproxy_template: default.conf.j2
```

Jinja2 template used to generate `haproxy.conf`.

#### haproxy_timeout_client

```yaml
haproxy_timeout_client: 600000
```

Client inactivity timeout in milliseconds.

#### haproxy_timeout_connect

```yaml
haproxy_timeout_connect: 10000
```

Backend connection timeout in milliseconds.

#### haproxy_timeout_queue

```yaml
haproxy_timeout_queue: 60000
```

Queue timeout in milliseconds.

#### haproxy_timeout_server

```yaml
haproxy_timeout_server: 600000
```

Server inactivity timeout in milliseconds.

#### haproxy_user

```yaml
haproxy_user: www
```

OS user to run HAProxy as.
