# nginx

Install and configure [nginx](https://nginx.org/) sites and stream proxies. The role validates the configuration with `nginx -t -c` before replacement and keeps a backup.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### nginx_access_log

```yaml
nginx_access_log: /dev/stderr
```

Specify where to output the access log. Using `/dev/stderr` allows nginx logs to be managed by [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### nginx_accf_data

```yaml
nginx_accf_data: true
```

Enable kernel-level buffering module [`accf_data`](https://man.freebsd.org/cgi/man.cgi?query=accf_data&sektion=9) support in nginx for HTTPS listeners (`accept_filter=dataready`).

#### nginx_accf_data_load

```yaml
nginx_accf_data_load: true
```

Load and enable the `accf_data` kernel module. Set this variable to `false` in jails.

#### nginx_accf_http

```yaml
nginx_accf_http: true
```

Enable kernel-level HTTP buffering module [`accf_http`](https://man.freebsd.org/cgi/man.cgi?query=accf_http&sektion=9) support in nginx for HTTP listeners (`accept_filter=httpready`).

#### nginx_accf_http_load

```yaml
nginx_accf_http_load: true
```

Load and enable the `accf_http` kernel module. Set this variable to `false` in jails.

#### nginx_client_body_buffer_size

```yaml
nginx_client_body_buffer_size: 32k
```

Buffer size for reading client request bodies. Requests larger than this value are written to a temporary file.

#### nginx_client_max_body_size

```yaml
nginx_client_max_body_size: 128m
```

Maximum allowed size of a client request body.

#### nginx_cloudflare

```yaml
nginx_cloudflare: false
```

Configure `set_real_ip_from` for client connections from IP ranges published by Cloudflare:

- [Cloudflare IPv4](https://www.cloudflare.com/ips-v4)
- [Cloudflare IPv6](https://www.cloudflare.com/ips-v6)

The IP list is updated every 7 days by a dedicated s6 service.

#### nginx_cloudflare_logger

```yaml
nginx_cloudflare_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/nginx-cloudflare/
```

Configure the Cloudflare IP updater logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### nginx_config

```yaml
nginx_config: ""
```

Extra nginx configuration inserted in the `http` block before server blocks.

#### nginx_drop_privileges_early

```yaml
nginx_drop_privileges_early: false
```

Drop privileges to `www` via `s6-setuidgid` before launching the nginx process. Must be set to `false` when `nginx_accf_http` or `nginx_accf_data` is `true` or when binding to privileged ports without kernel permission.

#### nginx_error_log

```yaml
nginx_error_log: /dev/stderr
```

Specify where to output the error log. Using `/dev/stderr` allows nginx error logs to be managed by [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### nginx_error_log_level

```yaml
nginx_error_log_level: info
```

Error log level for nginx.

#### nginx_gzip

```yaml
nginx_gzip: true
```

Enable gzip compression in the `http` block.

#### nginx_gzip_types

```yaml
nginx_gzip_types:
  - application/json
  - text/css
  - text/javascript
```

MIME types to compress with gzip in addition to `text/html`.

#### nginx_http

```yaml
nginx_http: true
```

Enable the `http` block in `nginx.conf`.

#### nginx_http_port

```yaml
nginx_http_port: 80
```

HTTP listen port for sites with `secure: false`.

#### nginx_https_port

```yaml
nginx_https_port: 443
```

HTTPS listen port for sites with `secure: true`.

#### nginx_ipv4

```yaml
nginx_ipv4: true
```

Listen on IPv4 addresses.

#### nginx_ipv6

```yaml
nginx_ipv6: false
```

Listen on IPv6 addresses (`[::]`).

#### nginx_keepalive_timeout

```yaml
nginx_keepalive_timeout: 120
```

Keep-alive timeout for client connections.

#### nginx_logger

```yaml
nginx_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/nginx/
```

Configure the nginx logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### nginx_server_names_hash_bucket_size

```yaml
nginx_server_names_hash_bucket_size: 64
```

Bucket size for the server names hash tables. See [nginx hash documentation](https://nginx.org/en/docs/hash.html).

#### nginx_sites

```yaml
nginx_sites: []
```

See [Configuring Sites](#configuring-sites) below.

#### nginx_ssl_protocols

```yaml
nginx_ssl_protocols: TLSv1 TLSv1.1 TLSv1.2 TLSv1.3
```

TLS protocols enabled for HTTPS sites and TLS stream proxies. Set it to `TLSv1.2 TLSv1.3` for sites that do not require older protocols.

#### nginx_stream

```yaml
nginx_stream: false
```

Enable [`ngx_stream_core_module`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html) for TCP and UDP proxying.

#### nginx_stream_config

```yaml
nginx_stream_config: ""
```

Extra nginx configuration inserted in the `stream` block before upstream blocks.

#### nginx_streams

```yaml
nginx_streams: []
```

See [Configuring Streams](#configuring-streams) below.

#### nginx_stub_status

```yaml
nginx_stub_status: false
```

Add a local status server at `nginx_stub_status_address` exposing `/stub_status` to `127.0.0.1` (all other paths on that server return `404`).

#### nginx_stub_status_address

```yaml
nginx_stub_status_address: 127.0.0.1:8181
```

Listen address and port for the `/stub_status` server when `nginx_stub_status` is `true`.

#### nginx_types_hash_max_size

```yaml
nginx_types_hash_max_size: 2048
```

Maximum size of the types hash tables.

#### nginx_worker_connections

```yaml
nginx_worker_connections: 256
```

Maximum number of simultaneous connections that can be opened by a worker process.

#### nginx_worker_processes

```yaml
nginx_worker_processes: 2
```

Number of worker processes (`auto` or an integer).

## Configuring Sites

`nginx_sites` configures HTTP and HTTPS virtual hosts in YAML format:

```yaml
nginx_sites:
  - secure: false
    default: true
    domains:
      - example.com
    locations:
      - path: /
        redirect_match: "^/(.*)$"
        redirect_target: "https://example.com/$1"

  - secure: true
    default: true
    dehydrated_cert: example.com
    root: /var/www
    domains:
      - example.com
    locations:
      - path: "~ \\.php$"
        fastcgi_connect_timeout: 3s
        fastcgi_backends:
          - 127.0.0.1:4123
      - path: "/foo"
        proxy_name: foo
        proxy_connect_timeout: 3s
        proxy_backends:
          - 127.0.0.1:8080 weight=5
          - 127.0.0.1:8081
```

#### secure

```yaml
secure: false
```

Listen on `nginx_https_port` with SSL and HTTP/2 enabled. Either `dehydrated_cert` or both `cert` and `cert_key` must be configured.

#### config

```yaml
config: |
  # nginx config here
```

Free-form configuration placed in the `server` block before `location` blocks.

#### cert

```yaml
cert: /path/to/cert.pem
```

Path to the SSL certificate for this site.

#### cert_key

```yaml
cert_key: /path/to/cert.key
```

Path to the SSL certificate key for this site.

#### dehydrated_cert

```yaml
dehydrated_cert: example.com
```

Use the certificate and key provisioned by [`dehydrated`](../dehydrated/README.md) at `/usr/local/etc/dehydrated/certs/<dehydrated_cert>/`.

#### default

```yaml
default: true
```

Mark this site as `default_server` on its listen port.

#### domains

```yaml
domains:
  - example.com
```

List of domain names for `server_name`. Defaults to `_` if omitted.

#### root

```yaml
root: /var/www
```

Document root for the site. Also sets `absolute_redirect off;`.

#### locations

```yaml
locations:
  - path: "~ \\.php$"
    fastcgi_connect_timeout: 3s
    fastcgi_backends:
      - 127.0.0.1:4123
  - path: "/foo"
    proxy_name: foo
    proxy_connect_timeout: 3s
    proxy_backends:
      - 127.0.0.1:8080 weight=5
      - 127.0.0.1:8081
```

List of `location` blocks for the site. Each item requires `path`, which supports standard nginx location modifiers (`=`, `~`, `~*`, `^~`, or prefix match).

##### Redirection

```yaml
locations:
  - path: /
    redirect_match: "^/(.*)$"
    redirect_target: "https://example.com/$1"
```

- `redirect_match` — regular expression to match in `rewrite`
- `redirect_target` — target URL (can reference capture groups like `$1`)

##### Proxy

```yaml
locations:
  - path: "/foo"
    proxy_name: foo
    proxy_connect_timeout: 3s
    proxy_backends:
      - 127.0.0.1:8080 weight=5
      - 127.0.0.1:8081
```

- `proxy_name` — name of an `upstream` block (`<proxy_name>_proxy`)
- `proxy_secure` — connect to backend over `https` when `true`
- `proxy_backends` — list of backend servers
- `proxy_connection_upgrade` — pass `Upgrade` and `Connection "Upgrade"` headers for WebSockets
- `proxy_read_timeout` — timeout for reading a response from backend servers
- `proxy_connect_timeout` — timeout for connecting to backend servers

##### FastCGI

```yaml
locations:
  - path: "~ \\.php$"
    fastcgi_name: php
    fastcgi_read_timeout: 3s
    fastcgi_connect_timeout: 3s
    fastcgi_backends:
      - 127.0.0.1:4123
      - unix:/var/run/php.sock
```

- `fastcgi_name` — name of a FastCGI upstream block
- `fastcgi_backends` — list of FastCGI backend servers
- `fastcgi_read_timeout` — timeout for reading from FastCGI backend
- `fastcgi_connect_timeout` — timeout for connecting to FastCGI backend

##### Free-Form

```yaml
locations:
  - path: /
    config: |
      # nginx config here
```

Free-form directives placed inside the `location { }` block.

## Configuring Streams

`nginx_streams` configures TCP and UDP stream proxies when `nginx_stream: true`:

```yaml
nginx_streams:
  - secure: true
    port: 4000
    bind: true
    dehydrated_cert: example.com
    proxy_name: upstream
    proxy_backends:
      - 10.0.0.40:8667
```

#### secure

```yaml
secure: false
```

Enable TLS termination on the stream listener.

#### cert

```yaml
cert: /path/to/cert.pem
```

Path to the SSL certificate for this stream.

#### cert_key

```yaml
cert_key: /path/to/cert.key
```

Path to the SSL certificate key for this stream.

#### dehydrated_cert

```yaml
dehydrated_cert: example.com
```

Use the certificate and key provisioned by [`dehydrated`](../dehydrated/README.md) at `/usr/local/etc/dehydrated/certs/<dehydrated_cert>/`.

#### port

```yaml
port: 4000
```

Port to listen on.

#### bind

```yaml
bind: false
```

Make a separate `bind()` call for the given address:port pair.

#### proxy_protocol

```yaml
proxy_protocol: false
```

Enable the `proxy_protocol` parameter on the stream listener.

#### udp

```yaml
udp: false
```

Listen for UDP packets instead of TCP connections.

#### reuseport

```yaml
reuseport: false
```

Create an individual listening socket for each worker process (`reuseport`).

#### proxy_name

```yaml
proxy_name: upstream
```

Name used to declare the stream `upstream` block (`<proxy_name>_stream`).

#### proxy_backends

```yaml
proxy_backends:
  - 10.0.0.40:8667
```

List of backend servers in the stream `upstream` block.

#### proxy_read_timeout

```yaml
proxy_read_timeout: 30s
```

Timeout between two successive read or write operations on client or proxied server connections.

#### proxy_connect_timeout

```yaml
proxy_connect_timeout: 30s
```

Timeout for establishing a connection with a proxied server.
