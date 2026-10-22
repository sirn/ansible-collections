# postgresql

Configure [PostgreSQL](https://www.postgresql.org/).

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### postgresql_addresses

```yaml
postgresql_addresses:
  - "*"
```

List of TCP addresses for PostgreSQL to listen on (`listen_addresses`).

#### postgresql_databases

```yaml
postgresql_databases:
  - user: "{{ ansible_user }}"
    password: "passw0rd"
    databases:
      - "{{ ansible_user }}"
```

List of PostgreSQL users and databases to create during setup. Change the default password in inventory:

- `user` — PostgreSQL role name
- `password` — password for the user (optional)
- `databases` — list of database names to create with `user` as owner

#### postgresql_dir

```yaml
postgresql_dir: /var/db/postgres
```

Base directory where PostgreSQL data (`{{ postgresql_dir }}/data{{ postgresql_version }}`) is stored.

#### postgresql_group

```yaml
postgresql_group: postgres
```

Group that owns PostgreSQL data and configuration files.

#### postgresql_group_create

```yaml
postgresql_group_create: false
```

Create `postgresql_group` if it does not exist.

#### postgresql_group_extra_users

```yaml
postgresql_group_extra_users: []
```

Extra users to add to `postgresql_group`.

#### postgresql_hba

```yaml
postgresql_hba:
  - { type: host, database: all, user: all, address: 0.0.0.0/0, method: md5 }
```

Host-based authentication rules written to `pg_hba.conf`. See [The pg_hba.conf File](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html).

#### postgresql_hba_trust_local

```yaml
postgresql_hba_trust_local: false
```

Allow local socket connections (`local all all trust`) without password authentication in `pg_hba.conf`.

#### postgresql_logger

```yaml
postgresql_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/postgresql/
```

Configure the PostgreSQL logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### postgresql_max_connections

```yaml
postgresql_max_connections: 256
```

Maximum number of concurrent connections to the database server (`max_connections`).

#### postgresql_port

```yaml
postgresql_port: 5432
```

TCP port for PostgreSQL to listen on (`port`).

#### postgresql_python_version

```yaml
postgresql_python_version: "3.9"
```

Python version used to install `python`, `pip`, and `psycopg2` for Ansible database management.

#### postgresql_shared_buffers

```yaml
postgresql_shared_buffers: 512MB
```

Amount of memory dedicated to PostgreSQL for shared memory buffers (`shared_buffers`).

#### postgresql_tls

```yaml
postgresql_tls: false
```

Enable SSL connections (`ssl = on`) in `postgresql.conf`.

#### postgresql_tls_cert_file

```yaml
postgresql_tls_cert_file:
```

Path to the SSL server certificate file (`ssl_cert_file`) when `postgresql_tls` is `true`.

#### postgresql_tls_key_file

```yaml
postgresql_tls_key_file:
```

Path to the SSL server private key file (`ssl_key_file`) when `postgresql_tls` is `true`.

#### postgresql_unix_socket_directories

```yaml
postgresql_unix_socket_directories:
  - /var/run/postgresql
```

Directories where PostgreSQL creates Unix-domain sockets (`unix_socket_directories`).

#### postgresql_user

```yaml
postgresql_user: postgres
```

OS user that owns the PostgreSQL database cluster.

#### postgresql_user_create

```yaml
postgresql_user_create: false
```

Create `postgresql_user` if it does not exist. Note that `postgresql_prefix` must be defined when `postgresql_user_create` is `true`.

#### postgresql_version

```yaml
postgresql_version: 10
```

PostgreSQL major version package suffix to install from pkg (`postgresql<version>-server` and `postgresql<version>-client`).
