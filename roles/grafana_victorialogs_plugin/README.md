# grafana_victorialogs_plugin

Build and install the VictoriaLogs Grafana plugin.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host. AMD64 and ARM64 are supported.

## Configuration

Configure Grafana before running this role. Set
`grafana_allow_loading_unsigned_plugins` to include
`victoriametrics-logs-datasource`. Provision its datasource separately
through `grafana_datasources`.

- `grafana_victorialogs_plugin_version`: `0.32.0`.
- `grafana_victorialogs_plugin_src`: host package path under
  `/var/cache/grafana-logs-plugin/` by default.
- `grafana_victorialogs_plugin_build_dir`: build files under `/var/cache/`.
- `grafana_victorialogs_plugin_dir`: `/var/db/grafana/plugins`.
  Change it when Grafana uses a different data directory.

Ansible builds a missing package on the host using the upstream release
frontend and source backend. It installs `go127` and `gtar` from pkg and
verifies the source and release archive checksums. The host needs network
access for the first build. Check mode reports missing builds without
compiling or changing the host. For version updates, update both archive
checksums.

The role removes `MANIFEST.txt` because the upstream signature does not
cover the rebuilt backend. Plugin changes restart Grafana.
