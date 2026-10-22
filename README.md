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
| `varnish_ncsa_config` | Replace only the Varnish access-log service and logger |
| `nginx_config` | Validate and replace nginx configuration |
| `php_config` | Validate and replace the PHP-FPM pool configuration |
| `haproxy_config` | Validate and replace HAProxy configuration |
| `mysql_tools` | Install Python database dependencies |
| `mysql_users` | Manage users declared in `mysql_databases` |
| `sanoidconfig` | Replace Sanoid configuration and ensure state directory |
| `sanoidhooks` | Generate Sanoid dataset and template hook scripts |

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

- [`hardening`](roles/hardening/README.md) — harden a host (SSH, sudo, sysctl, accounting)
- [`ntpd`](roles/ntpd/README.md) — configure the base ntpd time synchronization on FreeBSD
- [`openntpd`](roles/openntpd/README.md) — configure OpenNTPd on FreeBSD or OpenBSD
- [`pf`](roles/pf/README.md) — configure the pf firewall
- [`racct`](roles/racct/README.md) — enable FreeBSD resource limits
- [`tuning`](roles/tuning/README.md) — tune FreeBSD kernel and boot parameters
- [`s6`](roles/s6/README.md) — install and enable the s6 supervisor on FreeBSD

### Services (s6-supervised on FreeBSD)

- [`dehydrated`](roles/dehydrated/README.md) — Let's Encrypt certificate provisioning
- [`duplicity`](roles/duplicity/README.md) — encrypted periodic backups
- [`haproxy`](roles/haproxy/README.md) — HAProxy load balancer
- [`hitch`](roles/hitch/README.md) — TLS termination proxy
- [`mrtg`](roles/mrtg/README.md) — network traffic monitoring
- [`mysql`](roles/mysql/README.md) — MariaDB database server
- [`nginx`](roles/nginx/README.md) — web server
- [`openssh`](roles/openssh/README.md) — OpenSSH server via pkg
- [`php`](roles/php/README.md) — PHP-FPM runtime
- [`postgresql`](roles/postgresql/README.md) — PostgreSQL database server
- [`redis`](roles/redis/README.md) — Redis key-value store
- [`sanoid`](roles/sanoid/README.md) — ZFS snapshot management
- [`varnish`](roles/varnish/README.md) — Varnish cache
- [`victoria_metrics`](roles/victoria_metrics/README.md) — single-node metrics storage
- [`victoria_logs`](roles/victoria_logs/README.md) — single-node log storage
- [`vlagent`](roles/vlagent/README.md) — file collection and queued log delivery
- [`vmagent`](roles/vmagent/README.md) — metrics scraping and queued remote write
- [`grafana`](roles/grafana/README.md) — dashboards and datasource provisioning
- [`grafana_victorialogs_plugin`](roles/grafana_victorialogs_plugin/README.md) — local VictoriaLogs plugin build and installation
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
