# sirn.collections

Personal Ansible collection of OS-agnostic roles for FreeBSD and OpenBSD hosts.
Service roles supervise their processes with
[s6](https://www.skarnet.org/software/s6/) on FreeBSD.

## Installation

Add the collection to `requirements.yml`:

```yaml
- name: sirn.collections
  src: https://github.com/sirn/ansible-collections
  type: git
```

or build and install it from source:

```bash
ansible-galaxy collection build
ansible-galaxy collection install sirn-collections-1.0.0.tar.gz
```

## Usage

Use the collection namespace to select roles:

```yaml
- hosts: freebsd
  roles:
    - role: sirn.collections.hardening
    - role: sirn.collections.pf
```

Service roles supervise their process with s6 when the `s6` flag is set:

```yaml
- hosts: freebsd
  roles:
    - role: sirn.collections.haproxy
      vars:
        s6: true
```

## Task selection

Use these tags through the normal role entry point on configured FreeBSD
hosts with `s6: true`:

| Tag | Selected tasks |
|-----|----------------|
| `nginx_config` | Validate and replace nginx configuration |
| `php_config` | Validate and replace the PHP-FPM pool configuration |
| `haproxy_config` | Validate and replace HAProxy configuration |
| `mysql_tools` | Install Python database dependencies |
| `mysql_users` | Manage users declared in `mysql_databases` |

Configuration changes notify the role's service handlers. These tags do not
install service packages or change supervision. Database dependencies must
be installed before the `mysql_users` tasks can run.

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
`main_openbsd.yml`, and `main_freebsd_s6.yml`.

## Roles

### Platform configuration

- `hardening` — harden a host (SSH, sudo, sysctl, accounting)
- `ntpd` — configure the base ntpd time synchronization on FreeBSD
- `openntpd` — configure OpenNTPd on FreeBSD or OpenBSD
- `pf` — configure the pf firewall
- `racct` — enable FreeBSD resource limits
- `tuning` — tune FreeBSD kernel and boot parameters
- `s6` — install and enable the s6 supervisor on FreeBSD

### Services (s6-supervised on FreeBSD)

- `dehydrated` — Let's Encrypt certificate provisioning
- `duplicity` — encrypted periodic backups
- `haproxy` — HAProxy load balancer
- `hitch` — TLS termination proxy
- `mrtg` — network traffic monitoring
- `mysql` — MariaDB database server
- [`nginx`](roles/nginx/README.md) — web server
- `openssh` — OpenSSH server via pkg
- `php` — PHP-FPM runtime
- `postgresql` — PostgreSQL database server
- `redis` — Redis key-value store
- `sanoid` — ZFS snapshot management
- `varnish` — Varnish cache
- [`victoria_metrics`](roles/victoria_metrics/README.md) — single-node metrics storage
- [`vmagent`](roles/vmagent/README.md) — metrics scraping and queued remote write
- [`grafana`](roles/grafana/README.md) — dashboards and datasource provisioning
- [`blackbox_exporter`](roles/blackbox_exporter/README.md) — HTTP endpoint probes
- [`node_exporter`](roles/node_exporter/README.md) — FreeBSD host metrics
- [`mysqld_exporter`](roles/mysqld_exporter/README.md) — MySQL and MariaDB metrics
- [`redis_exporter`](roles/redis_exporter/README.md) — Redis metrics
- [`php_fpm_exporter`](roles/php_fpm_exporter/README.md) — PHP-FPM pool metrics
- [`nginx_exporter`](roles/nginx_exporter/README.md) — nginx stub-status metrics
- [`varnish_exporter`](roles/varnish_exporter/README.md) — Varnish metrics

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
