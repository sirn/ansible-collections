# sanoid

Configure [Sanoid](https://github.com/jimsalterjrs/sanoid) ZFS snapshot management and Syncoid replication.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### sanoid_datasets

```yaml
sanoid_datasets: []
```

Configures dataset sections in `/usr/local/etc/sanoid/sanoid.conf`:

- `name` — ZFS dataset name
- `options` — Sanoid options dictionary (see [`sanoid.defaults.conf`](https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf)):
  - `use_template` — template name (without the `template_` prefix)
  - `pre_snapshot_script` — script content written to a hook script under `{{ sanoid_prefix }}/hooks/`
  - `post_snapshot_script` — script content written to a hook script under `{{ sanoid_prefix }}/hooks/`
  - `pruning_script` — script content written to a hook script under `{{ sanoid_prefix }}/hooks/`

Example:

```yaml
sanoid_datasets:
  - name: zroot/home
    options:
      use_template: template1
      recursive: true
      process_children_only: true
      pre_snapshot_script: |
        mysql <<-EOF
        FLUSH TABLES WITH READ LOCK;
        EOF
      post_snapshot_script: |
        mysql <<-EOF
        UNLOCK TABLES;
        EOF
```

#### sanoid_logger

```yaml
sanoid_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/sanoid/
```

Configure the Sanoid logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### sanoid_prefix

```yaml
sanoid_prefix: /var/sanoid
```

Directory where Sanoid state, cache, and generated hook scripts are stored.

#### sanoid_snooze_args

```yaml
sanoid_snooze_args: "-d* -H* -v"
```

Arguments passed to `snooze` to schedule Sanoid runs. See [snooze](https://github.com/leahneukirchen/snooze).

#### sanoid_syncoid

```yaml
sanoid_syncoid: false
```

Enable Syncoid ZFS snapshot replication under a dedicated `sanoid-syncoid` s6 service.

#### sanoid_syncoid_compress

```yaml
sanoid_syncoid_compress: zstd-slow
```

Compression algorithm for Syncoid transfers (`gzip`, `pigz-fast`, `pigz-slow`, `zstd-fast`, `zstd-slow`, `lz4`, `xz`, `lzo`, or `none`).

#### sanoid_syncoid_logger

```yaml
sanoid_syncoid_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/sanoid-syncoid/
```

Configure the Syncoid logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### sanoid_syncoid_prefix

```yaml
sanoid_syncoid_prefix: "{{ sanoid_prefix }}/syncoid"
```

Directory where Syncoid state, `known_hosts`, and SSH keys are stored.

#### sanoid_syncoid_remote

```yaml
sanoid_syncoid_remote: ""
```

Default remote `user@host` target for Syncoid transfers.

#### sanoid_syncoid_snooze_args

```yaml
sanoid_syncoid_snooze_args: "-d* -H* -M30 -v"
```

Arguments passed to `snooze` to schedule Syncoid runs. See [snooze](https://github.com/leahneukirchen/snooze).

#### sanoid_syncoid_ssh_keygen

```yaml
sanoid_syncoid_ssh_keygen: true
```

Generate an SSH key pair at `sanoid_syncoid_ssh_keyfile` if it does not exist.

#### sanoid_syncoid_ssh_keyfile

```yaml
sanoid_syncoid_ssh_keyfile: "{{ sanoid_syncoid_prefix }}/id_{{ sanoid_syncoid_ssh_keytype }}"
```

Path to the SSH private key file used by Syncoid.

#### sanoid_syncoid_ssh_keytype

```yaml
sanoid_syncoid_ssh_keytype: ed25519
```

Type of SSH key to generate when `sanoid_syncoid_ssh_keygen` is `true`.

#### sanoid_syncoid_targets

```yaml
sanoid_syncoid_targets: []
```

List of datasets to replicate with Syncoid:

- `source` — local source ZFS dataset
- `dest` — destination dataset on the remote host
- `delete_target_snapshots` — pass `--delete-target-snapshots` when `true` (optional)
- `remote` — override `sanoid_syncoid_remote` for this target (optional)

Example:

```yaml
sanoid_syncoid_targets:
  - source: zroot/var/mysql
    dest: data1/backups/mysql
    delete_target_snapshots: true
  - source: zroot/var/www
    dest: data1/backups/www
    delete_target_snapshots: true
```

#### sanoid_templates

```yaml
sanoid_templates: []
```

Configures `[template_<name>]` sections in `/usr/local/etc/sanoid/sanoid.conf`:

- `name` — template name (`template_` prefix is added automatically)
- `options` — Sanoid retention and script options dictionary (including optional `pre_snapshot_script`, `post_snapshot_script`, and `pruning_script`)

Example:

```yaml
sanoid_templates:
  - name: template1
    options:
      frequently: 0
      hourly: 24
      daily: 7
      weekly: 5
      monthly: 12
      yearly: 1
```
