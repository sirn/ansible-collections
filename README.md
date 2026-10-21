# sirn.collections

Ansible collection of infrastructure roles for FreeBSD, OpenBSD, and Debian
hosts. Roles are grouped by domain: platform configuration, services,
observability, container services, and clusters.

Each role supports the platforms listed in its own `meta/main.yml`. A role
dispatches to a task file for the platform or the deployment method, so one
role name covers every supported target.

## Supervision

Service roles use the supervisor that the target platform provides:

- **FreeBSD**: service roles supervise processes with
  [s6](https://www.skarnet.org/software/s6/) when the `s6` variable is set.
- **Linux**: container roles run a Podman container under systemd.

Each container role has a deployment flag, for example `caddy_deploy_container`
or `oauth2_proxy_deploy_container`. The flag defaults to `false`. The role fails
when the flag is `false`.

Container settings follow these naming rules:

- Container-only settings carry the role prefix, for example
  `caddy_container_image` or `oauth2_proxy_container_image`.
- Container runtime settings carry the role prefix too, for example
  `caddy_container_runtime_binary` or
  `oauth2_proxy_container_runtime_api_service`. A host can run containers for
  one role and not for another.
- Method-independent settings use the role prefix without `container_`, for
  example `caddy_sites` or `oauth2_proxy_instances`.

## Installation

- From `requirements.yml`:

  ```yaml
  collections:
    - name: https://github.com/sirn/ansible-collections
      type: git
  ```

- From source:

  ```bash
  ansible-galaxy collection build
  ansible-galaxy collection install sirn-collections-1.0.0.tar.gz
  ```

## Usage

Use the collection namespace to select roles:

```yaml
- hosts: bsd_hosts
  roles:
    - role: sirn.collections.hardening
    - role: sirn.collections.pf
```

Set `s6` on a service role to supervise the service on a supported BSD host:

```yaml
- hosts: bsd_hosts
  roles:
    - role: sirn.collections.haproxy
      vars:
        s6: true
```

Set the deployment flag of a container role to run the container under
systemd:

```yaml
- hosts: linux_hosts
  roles:
    - role: sirn.collections.caddy
      vars:
        caddy_deploy_container: true
        caddy_http_port: "8080"
        caddy_sites:
          - domain: app.example.com
            reverse_proxy: 127.0.0.1:4180
```

## Task selection

These tags select part of a role. Run them through the normal role entry point
on a host where the role is already configured, and with `s6: true` on hosts
that use s6 supervision:

| Tag | Selected tasks |
|-----|----------------|
| `varnish_ncsa_config` | Replace only the Varnish access-log service and logger |
| `nginx_config` | Validate and replace nginx configuration |
| `php_config` | Validate and replace the PHP-FPM pool configuration |
| `haproxy_config` | Validate and replace HAProxy configuration and SPOE messages |
| `mysql_tools` | Install Python database dependencies |
| `mysql_users` | Manage users declared in `mysql_databases` |
| `sanoidconfig` | Replace Sanoid configuration and ensure state directory |
| `sanoidhooks` | Generate Sanoid dataset and template hook scripts |

Configuration changes notify the role's service handlers. The tags replace
configuration only. Install service packages and change supervision through the
full role. Install the database dependencies before the `mysql_users` tasks run.

## Role structure

Each role is OS-agnostic. `tasks/main.yml` is a dispatcher that includes a
per-OS entry point based on the target platform, with an optional `_s6` suffix
when s6 supervision is enabled:

```yaml
---
- name: include OS-specific tasks
  ansible.builtin.include_tasks: "main_{{ ansible_os_family | lower }}{{ '_s6' if s6 else '' }}.yml"
```

Only implemented entry points are shipped, for example `main_freebsd.yml`,
`main_openbsd.yml`, `main_debian.yml`, and `main_freebsd_s6.yml`. Roles with a
single implementation keep their tasks in `tasks/main.yml`.

## Roles

### Platform configuration

| Role | Platforms | Description |
|------|-----------|-------------|
| [`hardening`](roles/hardening/README.md) | FreeBSD, OpenBSD | Harden a host (SSH, sudo, sysctl, accounting) |
| [`ntpd`](roles/ntpd/README.md) | FreeBSD | Base ntpd time synchronization |
| [`openntpd`](roles/openntpd/README.md) | FreeBSD, OpenBSD | OpenNTPd time synchronization |
| [`pf`](roles/pf/README.md) | FreeBSD, OpenBSD | pf firewall |
| [`racct`](roles/racct/README.md) | FreeBSD | FreeBSD resource limits |
| [`tuning`](roles/tuning/README.md) | FreeBSD | FreeBSD kernel and boot parameters |
| [`wireguard`](roles/wireguard/README.md) | FreeBSD, Debian | WireGuard tunnel interfaces |
| [`s6`](roles/s6/README.md) | FreeBSD | Install and enable the s6 supervisor |

### Services

| Role | Platforms | Description |
|------|-----------|-------------|
| [`coraza_spoa`](roles/coraza_spoa/README.md) | FreeBSD | Detection-only WAF agent for HAProxy |
| [`dehydrated`](roles/dehydrated/README.md) | FreeBSD, OpenBSD | Let's Encrypt certificate provisioning |
| [`dhparam`](roles/dhparam/README.md) | FreeBSD | Mozilla ffdhe2048 DH parameter file |
| [`dnsmasq`](roles/dnsmasq/README.md) | FreeBSD | Forwarding DNS resolver with split-horizon records |
| [`duplicity`](roles/duplicity/README.md) | FreeBSD | Encrypted periodic backups |
| [`haproxy`](roles/haproxy/README.md) | FreeBSD | HAProxy load balancer |
| [`hitch`](roles/hitch/README.md) | FreeBSD | TLS termination proxy |
| [`mysql`](roles/mysql/README.md) | FreeBSD | MariaDB database server |
| [`nginx`](roles/nginx/README.md) | FreeBSD | Web server |
| [`openssh`](roles/openssh/README.md) | FreeBSD | OpenSSH server via pkg |
| [`php`](roles/php/README.md) | FreeBSD | PHP-FPM runtime |
| [`postgresql`](roles/postgresql/README.md) | FreeBSD | PostgreSQL database server |
| [`redis`](roles/redis/README.md) | FreeBSD | Redis key-value store |
| [`sanoid`](roles/sanoid/README.md) | FreeBSD | ZFS snapshot management |
| [`varnish`](roles/varnish/README.md) | FreeBSD | Varnish cache |

### Observability

| Role | Platforms | Description |
|------|-----------|-------------|
| [`victoria_metrics`](roles/victoria_metrics/README.md) | FreeBSD | Single-node metrics storage |
| [`victoria_logs`](roles/victoria_logs/README.md) | FreeBSD | Single-node log storage |
| [`vmagent`](roles/vmagent/README.md) | FreeBSD | Metrics scraping and queued remote write |
| [`vlagent`](roles/vlagent/README.md) | FreeBSD | File collection and queued log delivery |
| [`grafana`](roles/grafana/README.md) | FreeBSD | Dashboards and datasource provisioning |
| [`grafana_victorialogs_plugin`](roles/grafana_victorialogs_plugin/README.md) | FreeBSD | Local VictoriaLogs plugin build and installation |
| [`blackbox_exporter`](roles/blackbox_exporter/README.md) | FreeBSD | HTTP endpoint probes |
| [`node_exporter`](roles/node_exporter/README.md) | FreeBSD | Host metrics |
| [`mysqld_exporter`](roles/mysqld_exporter/README.md) | FreeBSD | MySQL and MariaDB metrics |
| [`redis_exporter`](roles/redis_exporter/README.md) | FreeBSD | Redis metrics |
| [`php_fpm_exporter`](roles/php_fpm_exporter/README.md) | FreeBSD | PHP-FPM pool metrics |
| [`nginx_exporter`](roles/nginx_exporter/README.md) | FreeBSD | nginx stub-status metrics |
| [`varnish_exporter`](roles/varnish_exporter/README.md) | FreeBSD | Varnish metrics |
| [`mrtg`](roles/mrtg/README.md) | FreeBSD | Network traffic monitoring |

### Container services

Roles that run services in Podman containers under systemd.

| Role | Platforms | Description |
|------|-----------|-------------|
| [`caddy`](roles/caddy/README.md) | Linux with containers | Shared TLS ingress and reverse proxy |
| [`oauth2_proxy`](roles/oauth2_proxy/README.md) | Linux with containers | Per-instance authentication front |

### Clusters

| Role | Platforms | Description |
|------|-----------|-------------|
| [`rke2`](roles/rke2/README.md) | Debian | RKE2 server and agent nodes |

## Development

Use the provided Nix flake to get `ansible`, `ansible-lint`, and `yamllint`:

```bash
nix develop
yamllint roles/ tests/
ansible-lint
for test in tests/*.yml; do
  ansible-playbook -i localhost, "$test" || break
done
```
