# hitch

Configure [Hitch](https://hitch-tls.org/) TLS termination proxy.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### hitch_backend_address

```yaml
hitch_backend_address: "[127.0.0.1]:80"
```

Backend address and port to forward decrypted connections to.

#### hitch_drop_privileges_early

```yaml
hitch_drop_privileges_early: false
```

Drop privileges to `www` via `s6-setuidgid` before starting Hitch instead of letting Hitch drop privileges itself.

#### hitch_enable_proxy_v2

```yaml
hitch_enable_proxy_v2: true
```

Enable `write-proxy-v2 = on` and `alpn-protos = "h2,http/1.1"` when forwarding connections to the backend.

#### hitch_frontends

```yaml
hitch_frontends:
  - address: "*"
    port: "443"
    dehydrated_certs:
      - example.com
```

List of frontend listeners:

- `address` — listen address
- `port` — listen port
- `dehydrated_certs` — list of certificate names under `/usr/local/etc/dehydrated/certs/<cert>/fullbundle.pem` (optional)
- `certs` — list of explicit PEM certificate file paths (optional)

#### hitch_logger

```yaml
hitch_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/hitch/
```

Configure the Hitch logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).
