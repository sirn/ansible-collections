# coraza_spoa

Install and configure [Coraza SPOA](https://github.com/corazawaf/coraza-spoa) for request inspection with HAProxy. The role validates the agent configuration before replacement. Configure HAProxy message routing and failure handling in the caller; the role does not connect HAProxy.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### coraza_spoa_applications

```yaml
coraza_spoa_applications:
  - name: default
    body_access: true
```

List of inspection policies:

- `name` — application name selected by HAProxy SPOE messages
- `body_access` — enable request-body inspection for this application

All applications use the embedded OWASP CRS with the `coraza_spoa_rule_engine` mode. Audit logging, debug logging, and response inspection are disabled. The caller must send only complete bodies within `coraza_spoa_body_limit` and the SPOE transport limit. Do not treat missing verdicts or transport errors as successful inspection.

#### coraza_spoa_binary

```yaml
coraza_spoa_binary: "/usr/local/libexec/coraza-spoa/{{ coraza_spoa_revision }}/coraza-spoa"
```

Path on the host where the compiled agent is cached and run. On FreeBSD, an absent binary triggers a static host build with CGO disabled and read-only module resolution. The role installs `coraza_spoa_go_package` and `gtar` for the build. Dependencies are downloaded during the build. Check mode reports missing builds without compiling or changing the host. Keep a revision-specific path when overriding this variable; an existing binary is not rebuilt.

#### coraza_spoa_body_limit

```yaml
coraza_spoa_body_limit: 13107200
```

Request-body limit in bytes. Sets `SecRequestBodyLimit`, `SecRequestBodyNoFilesLimit`, and `SecRequestBodyInMemoryLimit` for each application. Configure frontend buffering and body selection separately.

#### coraza_spoa_build_dir

```yaml
coraza_spoa_build_dir: "/var/cache/coraza-spoa-{{ coraza_spoa_revision }}"
```

Directory on the host used to download, extract, and compile the source archive. Also stores the Go build and module caches.

#### coraza_spoa_config_dir

```yaml
coraza_spoa_config_dir: /usr/local/etc/coraza-spoa
```

Directory for `coraza-spoa.yml`. The agent validates the configuration with `-validate -config` before replacement.

#### coraza_spoa_go_binary

```yaml
coraza_spoa_go_binary: /usr/local/bin/go126
```

Go executable used for the host build. Automatic Go toolchain downloads are disabled.

#### coraza_spoa_go_package

```yaml
coraza_spoa_go_package: go126
```

Go package installed from pkg for host builds on FreeBSD.

#### coraza_spoa_group

```yaml
coraza_spoa_group: www
```

Existing primary group for `coraza_spoa_user`. The HAProxy process must have access to this group to connect to the private socket.

#### coraza_spoa_logger

```yaml
coraza_spoa_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/coraza-spoa/
```

Configure the agent service logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

Agent and application logs use JSON on standard output. The default logger does not filter request values; rule matches and errors can contain private data. Override this variable to apply a log policy before writing output to disk. Install custom filters and their dependencies in the caller before running this role.

#### coraza_spoa_metrics_address

```yaml
coraza_spoa_metrics_address: 127.0.0.1:9000
```

Address and port for metrics and health checks (`-metrics-addr`). Keep the listener private. Configure scraping separately.

#### coraza_spoa_revision

```yaml
coraza_spoa_revision: 1c7f567f2dbde725a921fc570289bc6774759b70
```

Source commit to build. Its module files pin Coraza 3.7.0 and OWASP CRS 4.25.0. Update `coraza_spoa_version` and `coraza_spoa_source_sha256` when changing the revision.

#### coraza_spoa_rule_engine

```yaml
coraza_spoa_rule_engine: DetectionOnly
```

Engine mode for every application. `DetectionOnly` reports matches and takes no disruptive action. `On` lets CRS blocking rules interrupt the request, which the agent reports as `txn.<prefix>.action`; the caller must deny on that variable to enforce it. The SPOE `detect-only` flag only sets the reported mode and metrics, so it does not suppress a verdict.

Quote the value. A bare `On` is a YAML boolean and renders as `SecRuleEngine True`, which the agent rejects.

#### coraza_spoa_socket

```yaml
coraza_spoa_socket: /var/run/coraza-spoa/coraza-spoa.sock
```

Unix socket path for SPOE connections. On FreeBSD with s6, the role starts an unprivileged agent with a `007` umask and recreates the socket directory with mode `0750` at service startup. The role waits for the socket after starting the service.

#### coraza_spoa_source_sha256

```yaml
coraza_spoa_source_sha256: 9a1b5b347f3d4a1e4bb36f7d056659a7898ce47ebda37eeab2c6c62d823be666
```

SHA-256 checksum for the source archive. The role verifies it before extraction.

#### coraza_spoa_source_url

```yaml
coraza_spoa_source_url: "https://codeload.github.com/corazawaf/coraza-spoa/tar.gz/{{ coraza_spoa_revision }}"
```

Download URL for the source archive. The archive must contain `coraza-spoa-{{ coraza_spoa_revision }}`.

#### coraza_spoa_user

```yaml
coraza_spoa_user: coraza-spoa
```

OS user created to run the agent, with no home directory and a non-login shell.

#### coraza_spoa_version

```yaml
coraza_spoa_version: 0.9.0
```

Version string embedded in the compiled binary. `coraza_spoa_revision` selects the source to build.
