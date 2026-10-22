# caddy

Run [Caddy](https://caddyserver.com/) as a shared TLS ingress and reverse proxy.
The role supports DNS-01 ACME challenges through provider plugins. The role also
supports plain HTTP for an upstream TLS termination proxy.

## Supported platforms

- Linux with Podman and systemd

### Linux containers

The role has one deployment method: a host-network Podman container under
systemd. The role requires Podman and systemd.

## Usage

```yaml
- hosts: linux_hosts
  roles:
    - role: sirn.collections.caddy
      vars:
        caddy_deploy_container: true
        caddy_acme_email: admin@example.com
        caddy_container_image: localhost/caddy-cloudflare:latest
        caddy_container_image_build_enabled: true
        caddy_container_image_build_args:
          - --build-arg
          - CADDY_PLUGINS=--with github.com/caddy-dns/cloudflare
        caddy_tls_dns_provider: cloudflare
        caddy_tls_dns_options:
          api_token: "{$CF_API_TOKEN}"
        caddy_container_env:
          CF_API_TOKEN: "{{ cloudflare_api_token }}"
        caddy_sites:
          - domain: app.example.com
            reverse_proxy: 127.0.0.1:4180
```

A DNS-01 provider plugin lives in the Caddy binary, so the example builds an
image from the bundled context. Keep `caddy_container_image_build_enabled: false`
to use an existing image. Any image with the plugin compiled in works.

Caddy expands `{$NAME}` placeholders in the Caddyfile from container environment
variables. Pass these variables through `caddy_container_env`. The role writes
the map to `caddy_container_env_file` with mode `0600` and passes the file to
the container with `--env-file`.

## Variables

### Linux containers

#### caddy_deploy_container

```yaml
caddy_deploy_container: false
```

Deploy Caddy as a Podman container under systemd. Set to `true` to run the
container tasks. The role fails when this is `false`.

#### caddy_container_runtime_binary

```yaml
caddy_container_runtime_binary: "/usr/bin/podman"
```

Path to the container runtime binary. Each container role has its own copy, so a
host can run containers for one role and not for another.

#### caddy_container_runtime_api_service

```yaml
caddy_container_runtime_api_service: ""
```

Name of the container runtime systemd socket service, without `.service`, for
example `podman-api`. When set, the generated service adds `Requires` and `After`
dependencies on `<name>.service`. Keep empty to omit the dependency.

#### caddy_container_image

```yaml
caddy_container_image: "docker.io/caddy:2"
```

Container image to run.

#### caddy_container_image_build_enabled

```yaml
caddy_container_image_build_enabled: false
```

Build the image from `caddy_container_image_build_context`. The role rebuilds the
image when the context, the image name, the build file or the build arguments
change, and when the image is missing. The handler restarts Caddy only when the
built image digest changes.

#### caddy_container_image_build_context

```yaml
caddy_container_image_build_context: "caddy-image"
```

Build context directory inside the role `files/` directory. The role copies this
directory to `{{ caddy_data_dir }}/image-builds/{{ caddy_container_image_build_context }}/`.

#### caddy_container_image_build_file

```yaml
caddy_container_image_build_file: "Containerfile"
```

Containerfile name inside the build context directory.

#### caddy_container_image_build_args

```yaml
caddy_container_image_build_args: []
```

Extra arguments passed to `podman build`. The bundled `caddy-image` context uses
`CADDY_PLUGINS` with `--with` flags for `xcaddy`:

```yaml
caddy_container_image_build_args:
  - --build-arg
  - CADDY_PLUGINS=--with github.com/caddy-dns/cloudflare
```

#### caddy_container_name

```yaml
caddy_container_name: "caddy"
```

Name of the Podman container.

#### caddy_container_service_name

```yaml
caddy_container_service_name: "caddy"
```

Name of the systemd service that manages the container. The role writes
`/etc/systemd/system/{{ caddy_container_service_name }}.service` with mode
`0644`.

#### caddy_container_manage_service

```yaml
caddy_container_manage_service: true
```

Enable and start the systemd service. Set to `false` to write the unit file
without starting or enabling the service.

#### caddy_container_env

```yaml
caddy_container_env: {}
```

Environment variables passed to the container. Caddy expands `{$NAME}`
placeholders in the Caddyfile from these variables. Values are often secrets, so
the role keeps them out of the world-readable service unit.

#### caddy_container_env_file

```yaml
caddy_container_env_file: "{{ caddy_data_dir }}/container.env"
```

Path to the environment file. The role writes it with `caddy_container_env` as
`KEY=VALUE` lines, mode `0600`, owned by `caddy_user` and `caddy_group`. The
service passes it to the container with `--env-file`.

#### caddy_container_secret_files

```yaml
caddy_container_secret_files: []
```

Secret files written before the container starts. The role creates the parent
directory of each file, then writes the file with mode `0600`, owned by
`caddy_user` and `caddy_group`. Keep secret content in an
encrypted variable file:

```yaml
caddy_container_secret_files:
  - dest: "{{ caddy_data_dir }}/secrets/provider.json"
    content: "{{ caddy_provider_credentials }}"
```

#### caddy_container_volumes

```yaml
caddy_container_volumes: []
```

Extra volume mounts passed to `podman run` as `--volume <string>`. The role
always mounts the Caddyfile read-only, plus the `data/` and `config/`
directories.

#### caddy_container_memory

```yaml
caddy_container_memory: "512m"
```

Memory limit for the container.

#### caddy_container_cpus

```yaml
caddy_container_cpus: "1.0"
```

CPU limit for the container.

#### caddy_container_pids_limit

```yaml
caddy_container_pids_limit: 128
```

Maximum number of processes in the container.

#### caddy_container_security_options

```yaml
caddy_container_security_options:
  - "no-new-privileges:true"
```

Security options passed to `podman run` with `--security-opt`.

#### caddy_container_cap_drop

```yaml
caddy_container_cap_drop:
  - "NET_RAW"
  - "MKNOD"
  - "AUDIT_WRITE"
  - "SETFCAP"
  - "SYS_CHROOT"
```

Linux capabilities dropped from the container with `--cap-drop`.

#### caddy_container_healthcheck_cmd

```yaml
caddy_container_healthcheck_cmd: "wget -q -O /dev/null -T 5 http://127.0.0.1:2019/config/"
```

Health check command run inside the container. Set to "" to disable the
health check.

#### caddy_container_healthcheck_interval

```yaml
caddy_container_healthcheck_interval: "30s"
```

Interval between health checks.

#### caddy_container_healthcheck_timeout

```yaml
caddy_container_healthcheck_timeout: "15s"
```

Time to wait for a health check to complete.

#### caddy_container_healthcheck_retries

```yaml
caddy_container_healthcheck_retries: 3
```

Number of failures before the container becomes unhealthy.

#### caddy_container_healthcheck_start_period

```yaml
caddy_container_healthcheck_start_period: "30s"
```

Grace period after container start where failed health checks do not count.

#### caddy_container_healthcheck_on_failure

```yaml
caddy_container_healthcheck_on_failure: "kill"
```

Action when a health check fails. The value `kill` stops the container, and
systemd restarts it.

### Caddyfile settings

#### caddy_user

```yaml
caddy_user: "caddy"
```

User on the host that owns Caddy directories and files.

#### caddy_manage_user

```yaml
caddy_manage_user: true
```

Create `caddy_user` and `caddy_group` as system accounts when they are missing.
Set to `false` when the host already provides them, for example when another
role owns the account.

#### caddy_group

```yaml
caddy_group: "{{ caddy_user }}"
```

Group on the host that owns Caddy directories and files. Defaults to
`caddy_user`.

#### caddy_data_dir

```yaml
caddy_data_dir: "/var/lib/caddy"
```

Host directory for persistent Caddy data. The role creates this directory and
its `data/` and `config/` subdirectories with mode `0750`.

#### caddy_config_dir

```yaml
caddy_config_dir: "{{ caddy_data_dir }}"
```

Host directory for configuration files. The role writes
`{{ caddy_config_dir }}/Caddyfile` with mode `0640`. Defaults to
`caddy_data_dir`.

#### caddy_acme_email

```yaml
caddy_acme_email: ""
```

Email address registered with the ACME CA. When empty, Caddy requests
certificates without an email address.

#### caddy_tls_dns_provider

```yaml
caddy_tls_dns_provider: ""
```

DNS-01 TLS provider plugin name, for example `cloudflare` or `route53`. Leave
empty to disable the DNS challenge and turn off automatic HTTPS.

#### caddy_tls_dns_options

```yaml
caddy_tls_dns_options: {}
```

Options written inside the `dns` block for the provider plugin:

```yaml
caddy_tls_dns_options:
  api_token: "{$CF_API_TOKEN}"
```

Option names match the plugin requirements. Values can reference container
environment variables with `{$NAME}`.

#### caddy_http_port

```yaml
caddy_http_port: ""
```

Port for plain HTTP site blocks when `caddy_tls_dns_provider` is empty. The role
renders site blocks as `http://<domain>:<port>`. Caddy ignores this variable
when `caddy_tls_dns_provider` is set. Set one of the two: the role fails when
both are empty, because Caddy then serves an HTTPS site without certificates.

#### caddy_sites

```yaml
caddy_sites: []
```

List of Caddy site blocks. Each entry supports these keys:

- `domain`: Hostname to serve.
- `redirect`: Target hostname for an HTTP 302 redirect.
- `reverse_proxy`: Upstream address for reverse proxy.
- `host_header`: Host header sent to the upstream.
- `strip_origin`: Drop the incoming `Origin` header. Defaults to `false`. Enable
  it only when the upstream rejects requests after `host_header` rewrites the
  Host, because WebSocket upgrades bypass HTTP middleware and check `Origin`
  again.
