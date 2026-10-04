# grafana

Install and configure Grafana dashboards and datasource provisioning.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

Required inputs:

- `grafana_domain`: public dashboard hostname.
- `grafana_root_url`: HTTPS dashboard URL.
- `grafana_admin_password`: initial admin password from the caller's secret store.
- `grafana_datasource_url`: VictoriaMetrics URL.

The HTTP listener defaults to `127.0.0.1:3000`. Configure TLS in the
caller's reverse proxy. Anonymous access, sign-up, and auth proxy are disabled.
The datasource UID is `victoriametrics`.

`grafana_dashboards` is a list of `{ src: controller_file, filename: name.json }`.
Filenames can contain letters, digits, underscores, and hyphens.
The role owns `/usr/local/etc/grafana/dashboards` and removes JSON files
not in that list. Data and plugins are stored in `grafana_data_dir`,
which defaults to `/var/db/grafana`.

The initial admin password applies only to a new Grafana database.
Passwords cannot contain newlines or triple double quotes.
The configuration task suppresses output and diffs.
