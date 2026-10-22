# oauth2_proxy

Run [OAuth2 Proxy](https://oauth2-proxy.github.io/) as an authentication front
for multiple upstreams. Each instance gets its own environment file. Upstreams
are protected independently.

## Supported platforms

- Linux with Podman and systemd

### Linux containers

The role has one deployment method: one Podman container and systemd unit per
instance. The role requires Podman and systemd.

## Usage

```yaml
- hosts: linux_hosts
  roles:
    - role: sirn.collections.oauth2_proxy
      vars:
        oauth2_proxy_deploy_container: true
        oauth2_proxy_env:
          OAUTH2_PROXY_SCOPE: openid email profile
        oauth2_proxy_instances:
          - name: dashboard
            data_dir: /var/lib/oauth2-proxy/dashboard
            upstream: http://127.0.0.1:3000
            redirect_url: https://app.example.com/oauth2/callback
            client_id: "{{ dashboard_client_id }}"
            client_secret: "{{ dashboard_client_secret }}"
            cookie_secret: "{{ dashboard_cookie_secret }}"
            oidc_issuer_url: https://auth.example.com
```

All provider settings travel through the environment file. The role writes one
environment file per instance to `{{ instance.data_dir }}/.env` with mode
`0600`.

Containers use host networking by default, so an instance reaches an upstream on
host loopback and Caddy reaches the instance on loopback. An instance that joins
a `pod` uses the pod network instead.

Global settings go into `oauth2_proxy_env`. Instance settings go into the
instance `env` map. Use full variable names, for example `OAUTH2_PROXY_SCOPE`.

The systemd unit starts the container with `--http-address` and `--env-file`.
The service unit name pattern is
`{{ oauth2_proxy_container_service_name_prefix }}-{{ instance.name }}.service`.
The container name pattern is
`{{ oauth2_proxy_container_name_prefix }}-{{ instance.name }}`.

## Variables

### Linux containers

#### oauth2_proxy_deploy_container

```yaml
oauth2_proxy_deploy_container: false
```

Deploy OAuth2 Proxy as Podman containers under systemd. Set to `true` to run the
container tasks. The role fails when this is `false`.

#### oauth2_proxy_container_runtime_binary

```yaml
oauth2_proxy_container_runtime_binary: "/usr/bin/podman"
```

Path to the container runtime binary. Each container role has its own copy, so a
host can run containers for one role and not for another.

#### oauth2_proxy_container_runtime_api_service

```yaml
oauth2_proxy_container_runtime_api_service: ""
```

Name of the container runtime systemd socket service, without `.service`, for
example `podman-api`. When set, the generated service adds `Requires` and `After`
dependencies on `<name>.service`. Keep empty to omit the dependency.

#### oauth2_proxy_container_network

```yaml
oauth2_proxy_container_network: "host"
```

Podman network mode for standalone containers. `host` lets an instance reach a
host-loopback upstream and lets Caddy reach the instance on loopback. Set to
`""` to let Podman use its default network, for example when instances join a
pod that carries the network settings. The role ignores this variable for an
instance that sets `pod`.

#### oauth2_proxy_container_image

```yaml
oauth2_proxy_container_image: "quay.io/oauth2-proxy/oauth2-proxy:v7.8.1"
```

Container image to run.

#### oauth2_proxy_container_name_prefix

```yaml
oauth2_proxy_container_name_prefix: "oauth2-proxy"
```

Prefix for container names. The container name is `<prefix>-<instance_name>`.

#### oauth2_proxy_container_service_name_prefix

```yaml
oauth2_proxy_container_service_name_prefix: "oauth2-proxy"
```

Prefix for systemd unit names. The role writes
`/etc/systemd/system/<prefix>-<instance_name>.service` with mode `0644`.

#### oauth2_proxy_container_manage_service

```yaml
oauth2_proxy_container_manage_service: true
```

Enable and start the systemd services. Set to `false` to write the unit files
without starting or enabling the services.

#### oauth2_proxy_container_memory

```yaml
oauth2_proxy_container_memory: "256m"
```

Memory limit for each container.

#### oauth2_proxy_container_cpus

```yaml
oauth2_proxy_container_cpus: "0.5"
```

CPU limit for each container.

#### oauth2_proxy_container_pids_limit

```yaml
oauth2_proxy_container_pids_limit: 128
```

Maximum number of processes in each container.

#### oauth2_proxy_container_security_options

```yaml
oauth2_proxy_container_security_options:
  - "no-new-privileges:true"
```

Security options passed to `podman run` with `--security-opt`.

#### oauth2_proxy_container_cap_drop

```yaml
oauth2_proxy_container_cap_drop: []
```

Linux capabilities dropped from each container with `--cap-drop`.

### Instance settings

#### oauth2_proxy_user

```yaml
oauth2_proxy_user: "oauth2proxy"
```

User on the host that owns instance directories and environment files.

#### oauth2_proxy_manage_user

```yaml
oauth2_proxy_manage_user: true
```

Create `oauth2_proxy_user` and `oauth2_proxy_group` as system accounts when they
are missing. Set to `false` when the host already provides them, for example when
another role owns the account.

#### oauth2_proxy_group

```yaml
oauth2_proxy_group: "{{ oauth2_proxy_user }}"
```

Group on the host that owns instance directories and environment files.
Defaults to `oauth2_proxy_user`.

#### oauth2_proxy_listen_address

```yaml
oauth2_proxy_listen_address: "127.0.0.1"
```

Default IP address each container binds to. Containers use the host network by
default, so loopback keeps an instance reachable by Caddy only. Use `0.0.0.0`
when clients reach an instance directly.

#### oauth2_proxy_listen_port

```yaml
oauth2_proxy_listen_port: 4180
```

Default port each container listens on.

#### oauth2_proxy_provider

```yaml
oauth2_proxy_provider: "oidc"
```

OAuth2 provider name. Written to `OAUTH2_PROXY_PROVIDER` in the environment
file.

#### oauth2_proxy_email_domain

```yaml
oauth2_proxy_email_domain: "*"
```

Email domains allowed to authenticate. Written to `OAUTH2_PROXY_EMAIL_DOMAINS`
in the environment file.

#### oauth2_proxy_pass_host_header

```yaml
oauth2_proxy_pass_host_header: false
```

Pass the client Host header to the upstream service. Written to
`OAUTH2_PROXY_PASS_HOST_HEADER` in the environment file.

#### oauth2_proxy_skip_provider_button

```yaml
oauth2_proxy_skip_provider_button: true
```

Skip the provider button on the sign-in page. Written to
`OAUTH2_PROXY_SKIP_PROVIDER_BUTTON` in the environment file.

#### oauth2_proxy_env

```yaml
oauth2_proxy_env: {}
```

Environment variables added to every instance. Use this map for extra provider
settings, for example `OAUTH2_PROXY_SCOPE`.

Set `OAUTH2_PROXY_INSECURE_OIDC_ALLOW_UNVERIFIED_EMAIL` here as `"true"` only
when the provider cannot verify email addresses.

#### oauth2_proxy_instances

```yaml
oauth2_proxy_instances: []
```

List of instances. Each entry supports these keys:

- `name`: Instance identifier. Used as the suffix for container and systemd
  service names (`<prefix>-<name>`).
- `data_dir`: Host directory for instance files. The role creates this
  directory with mode `0750` and writes `{{ data_dir }}/.env` with mode `0600`,
  owned by `oauth2_proxy_user` and `oauth2_proxy_group`.
- `listen_address`: Bind address for this instance. Defaults to
  `oauth2_proxy_listen_address`.
- `listen_port`: Port for this instance. Defaults to `oauth2_proxy_listen_port`.
  Containers share the host network, so give each instance its own port.
- `upstream`: Upstream URL to proxy (`OAUTH2_PROXY_UPSTREAMS`).
- `redirect_url`: OAuth callback URL (`OAUTH2_PROXY_REDIRECT_URL`).
- `client_id`: OAuth client ID (`OAUTH2_PROXY_CLIENT_ID`).
- `client_secret`: OAuth client secret (`OAUTH2_PROXY_CLIENT_SECRET`).
- `cookie_secret`: Cookie secret (`OAUTH2_PROXY_COOKIE_SECRET`).
- `pod`: Pod name to join. When omitted or empty, the container runs standalone
  without `--pod`.
- `oidc_issuer_url`: OIDC issuer URL (`OAUTH2_PROXY_OIDC_ISSUER_URL`). When
  omitted, the role omits the variable from `.env`.
- `env`: Extra environment variables added to this instance `.env` file.
- `depends_on`: List of systemd services added to `Requires` and `After` in the
  instance service unit.
