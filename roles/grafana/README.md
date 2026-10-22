# grafana

Install and configure [Grafana](https://grafana.com/) dashboards and datasource provisioning.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### grafana_admin_password

```yaml
grafana_admin_password: ""
```

Required. Initial admin password from the caller's secret store. The initial admin password applies only to a new Grafana database. Passwords cannot contain newlines or triple double quotes. The configuration task suppresses output and diffs.

#### grafana_admin_user

```yaml
grafana_admin_user: admin
```

Initial Grafana administrator username.

#### grafana_allow_loading_unsigned_plugins

```yaml
grafana_allow_loading_unsigned_plugins: []
```

List of exact plugin IDs permitted to load unsigned. Signature checks remain enabled for other plugins. Install plugins separately (for example with [`grafana_victorialogs_plugin`](../grafana_victorialogs_plugin/README.md)).

#### grafana_dashboards

```yaml
grafana_dashboards: []
```

List of dashboard files to provision:

- `src` — path to the dashboard JSON file on the controller
- `filename` — destination JSON basename (letters, digits, underscores, and hyphens)

The role owns `/usr/local/etc/grafana/dashboards` and removes JSON files not in this list.

#### grafana_data_dir

```yaml
grafana_data_dir: /var/db/grafana
```

Directory where Grafana stores its database, data, and plugins.

#### grafana_datasources

```yaml
grafana_datasources: []
```

Native Grafana datasource definitions, including `jsonData` and `secureJsonData`. The list is written unchanged to `provisioning/datasources/default.yml` with `apiVersion: 1`. Supply credentials through the caller's secret store. Task output and diffs are suppressed.

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

#### grafana_domain

```yaml
grafana_domain: ""
```

Required. Public dashboard hostname.

#### grafana_http_address

```yaml
grafana_http_address: 127.0.0.1
```

HTTP listen address. Configure TLS in the caller's reverse proxy. Anonymous access, sign-up, and auth proxy are disabled.

#### grafana_http_port

```yaml
grafana_http_port: 3000
```

HTTP listen port.

#### grafana_logger

```yaml
grafana_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/grafana/
```

Configure the Grafana logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### grafana_root_url

```yaml
grafana_root_url: ""
```

Required. Full HTTPS URL used to access Grafana.

#### grafana_user

```yaml
grafana_user: grafana
```

OS user to run Grafana as.
