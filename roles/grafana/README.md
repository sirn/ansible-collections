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

The HTTP listener defaults to `127.0.0.1:3000`. Configure TLS in the
caller's reverse proxy. Anonymous access, sign-up, and auth proxy are disabled.

`grafana_dashboards` is a list of `{ src: controller_file, filename: name.json }`.
Filenames can contain letters, digits, underscores, and hyphens.
The role owns `/usr/local/etc/grafana/dashboards` and removes JSON files
not in that list. Data and plugins are stored in `grafana_data_dir`,
which defaults to `/var/db/grafana`.

The initial admin password applies only to a new Grafana database.
Passwords cannot contain newlines or triple double quotes.
The configuration task suppresses output and diffs.

## Datasources

`grafana_datasources` defaults to `[]`. Supply native Grafana datasource
definitions, including `jsonData` and `secureJsonData`. The list is written
unchanged to `provisioning/datasources/default.yml` with `apiVersion: 1`.
Supply credentials through the caller's secret store. Task output and diffs
are suppressed.

Example:

```yaml
grafana_datasources:
  - name: Example
    uid: example
    type: graphite
    access: proxy
    url: http://192.0.2.10:8080
    isDefault: true
    editable: false
```

The role manages `default.yml` and removes its previous `victoriametrics.yml`
provisioning file. It does not remove other provisioning files or stored
datasources. An empty list does not delete existing datasources from Grafana.

## Plugins

Install plugins separately. `grafana_allow_loading_unsigned_plugins`
defaults to `[]`. Set it to the exact plugin IDs permitted to load unsigned.
Signature checks remain enabled for other plugins.
