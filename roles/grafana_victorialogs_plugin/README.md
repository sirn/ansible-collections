# grafana_victorialogs_plugin

Build and install the [VictoriaLogs Grafana datasource plugin](https://github.com/VictoriaMetrics/victorialogs-datasource).

Configure [`grafana`](../grafana/README.md) before running this role. Set `grafana_allow_loading_unsigned_plugins` to include `victoriametrics-logs-datasource` and provision its datasource separately through `grafana_datasources`.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`) on AMD64 and ARM64

## Variables

#### grafana_victorialogs_plugin_architecture

```yaml
grafana_victorialogs_plugin_architecture: "{{ {'x86_64': 'amd64', 'aarch64': 'arm64'}.get(ansible_architecture, ansible_architecture) }}"
```

Target Go architecture (`amd64` or `arm64`).

#### grafana_victorialogs_plugin_build_dir

```yaml
grafana_victorialogs_plugin_build_dir: "/var/cache/grafana-logs-plugin-v{{ grafana_victorialogs_plugin_version }}-freebsd-{{ grafana_victorialogs_plugin_architecture }}"
```

Directory on the host used to extract and compile the plugin backend.

#### grafana_victorialogs_plugin_dir

```yaml
grafana_victorialogs_plugin_dir: /var/db/grafana/plugins
```

Grafana plugins directory. Change it when Grafana uses a different `grafana_data_dir`. The role removes `MANIFEST.txt` because the upstream signature does not cover the rebuilt backend. Plugin changes restart Grafana.

#### grafana_victorialogs_plugin_release_sha256

```yaml
grafana_victorialogs_plugin_release_sha256: e100b767f19cd614ac8ac3860458a3fb33f5aa7a876e924d0340010e40d1c0d4
```

SHA-256 checksum for the upstream release archive.

#### grafana_victorialogs_plugin_release_url

```yaml
grafana_victorialogs_plugin_release_url: "https://github.com/VictoriaMetrics/victorialogs-datasource/releases/download/v{{ grafana_victorialogs_plugin_version }}/victoriametrics-logs-datasource-v{{ grafana_victorialogs_plugin_version }}.tar.gz"
```

Download URL for the prebuilt frontend release archive.

#### grafana_victorialogs_plugin_source_sha256

```yaml
grafana_victorialogs_plugin_source_sha256: 4cfefe7095bddf5743311b8fdcd6740706b5b125ab90d5750ab00943a7f3bc88
```

SHA-256 checksum for the upstream source archive.

#### grafana_victorialogs_plugin_source_url

```yaml
grafana_victorialogs_plugin_source_url: "https://codeload.github.com/VictoriaMetrics/victorialogs-datasource/tar.gz/refs/tags/v{{ grafana_victorialogs_plugin_version }}"
```

Download URL for the plugin source archive.

#### grafana_victorialogs_plugin_src

```yaml
grafana_victorialogs_plugin_src: "/var/cache/grafana-logs-plugin/victoriametrics-logs-datasource-v{{ grafana_victorialogs_plugin_version }}-freebsd-{{ grafana_victorialogs_plugin_architecture }}.tar.gz"
```

Path on the host where the built FreeBSD plugin archive is cached. When absent, the role installs `go127` and `gtar` from pkg and builds the package on the host. Check mode reports missing builds without compiling or changing the host.

#### grafana_victorialogs_plugin_version

```yaml
grafana_victorialogs_plugin_version: 0.32.0
```

Version of the VictoriaLogs datasource plugin to build and install. Update both archive checksums when changing the version.
