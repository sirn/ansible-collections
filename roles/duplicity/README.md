# duplicity

Configure [Duplicity](https://duplicity.gitlab.io/) for encrypted periodic backups using [snooze](https://github.com/leahneukirchen/snooze).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### duplicity_copy_links

```yaml
duplicity_copy_links: false
```

Copy contents of symlinks instead of the symlinks themselves (`--copy-links`).

#### duplicity_datadir

```yaml
duplicity_datadir: "{{ duplicity_dir }}/backup"
```

Directory containing the data to back up.

#### duplicity_dir

```yaml
duplicity_dir: /var/duplicity
```

Home and state directory for the `duplicity` user.

#### duplicity_full_if_older_than

```yaml
duplicity_full_if_older_than: 1W
```

Perform a full backup if the last full backup is older than the specified interval.

#### duplicity_gpg_recipients

```yaml
duplicity_gpg_recipients:
  - url: https://example.com/pgp_keys.asc
    id: "0000000000000000000000000000000000000000"
```

List of additional GPG recipient keys used to encrypt backups alongside the host's generated GPG key:

- `id` — full GPG key fingerprint
- `url` — optional URL to fetch the public key from (otherwise fetched via `gpg2 --recv-keys`)

#### duplicity_logger

```yaml
duplicity_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/duplicity/
```

Configure the Duplicity logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### duplicity_remove_all_inc_of_but_n_full

```yaml
duplicity_remove_all_inc_of_but_n_full: 4
```

Delete incremental backups of all full backup sets except the last `N` full backups.

#### duplicity_remove_older_than

```yaml
duplicity_remove_older_than: 12M
```

Delete all backup sets older than the specified time interval.

#### duplicity_scripts

```yaml
duplicity_scripts:
  - |
    redirfd -w 1 {{ duplicity_datadir }}/date.txt
    date +"%s"
```

Shell scripts executed in sequence before running `duplicity` to prepare files in `duplicity_datadir`.

#### duplicity_snooze

```yaml
duplicity_snooze: "-H*"
```

Arguments passed to `snooze` to schedule backup runs. See [snooze](https://github.com/leahneukirchen/snooze).

#### duplicity_ssh_dir

```yaml
duplicity_ssh_dir: "{{ duplicity_dir }}/.ssh"
```

Directory to store SSH keys for remote backup targets.

#### duplicity_ssh_keygen

```yaml
duplicity_ssh_keygen: true
```

Generate an SSH key pair at `duplicity_ssh_keyfile` if it does not exist.

#### duplicity_ssh_keyfile

```yaml
duplicity_ssh_keyfile: "{{ duplicity_ssh_dir }}/id_{{ duplicity_ssh_keytype }}"
```

Path to the SSH private key file for the `duplicity` user.

#### duplicity_ssh_keytype

```yaml
duplicity_ssh_keytype: ed25519
```

Type of SSH key to generate when `duplicity_ssh_keygen` is enabled.

#### duplicity_target

```yaml
duplicity_target: file:///tmp/backups
```

Destination URL for Duplicity backups.
