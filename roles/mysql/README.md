# mysql

Configure [MariaDB](https://mariadb.org/) database server.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### mysql_address

```yaml
mysql_address: "0.0.0.0"
```

IP address for `mysqld` to bind to (`bind-address`).

#### mysql_databases

```yaml
mysql_databases: []
```

List of database users and privilege grants to configure. Task output and diffs are suppressed. Each item accepts:

- `user` — MySQL username
- `host` — client host (for example `localhost`)
- `password` — user password (optional)
- `grants` — list of privilege strings in `db.table:PRIV1,PRIV2` format

Example:

```yaml
mysql_databases:
  - user: "{{ ansible_user }}"
    host: "localhost"
    password: "passw0rd"
    grants:
      - "{{ ansible_user }}_%.*:ALL"
```

#### mysql_dir

```yaml
mysql_dir: /var/db/mysql
```

Main database data directory (`datadir`).

#### mysql_dir_innodb

```yaml
mysql_dir_innodb: "{{ mysql_dir }}/innodb"
```

Directory for InnoDB tablespace files (`innodb_data_home_dir`).

#### mysql_dir_log

```yaml
mysql_dir_log: "{{ mysql_dir }}/log"
```

Directory for InnoDB redo log files (`innodb_log_group_home_dir`).

#### mysql_innodb_checksum_algorithm

```yaml
mysql_innodb_checksum_algorithm: "crc32"
```

Configure `innodb_checksum_algorithm` in `my.cnf`.

#### mysql_innodb_doublewrite

```yaml
mysql_innodb_doublewrite: "0"
```

Configure `innodb_doublewrite` in `my.cnf`.

#### mysql_innodb_flush_neighbors

```yaml
mysql_innodb_flush_neighbors: "0"
```

Configure `innodb_flush_neighbors` in `my.cnf`.

#### mysql_innodb_log_write_ahead_size

```yaml
mysql_innodb_log_write_ahead_size: "16384"
```

Configure `innodb_log_write_ahead_size` in `my.cnf`.

#### mysql_innodb_use_atomic_writes

```yaml
mysql_innodb_use_atomic_writes: "0"
```

Configure `innodb_use_atomic_writes` in `my.cnf`.

#### mysql_innodb_use_native_aio

```yaml
mysql_innodb_use_native_aio: "0"
```

Configure `innodb_use_native_aio` in `my.cnf`.

#### mysql_logger

```yaml
mysql_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/mysqld/
```

Configure the MariaDB logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### mysql_package

```yaml
mysql_package: "mariadb1011"
```

Package prefix for installing `<mysql_package>-client` and `<mysql_package>-server` from pkg.

#### mysql_password

```yaml
mysql_password: "passw0rd"
```

Password for the `root@localhost` database superuser. Change this in inventory.

#### mysql_python_version

```yaml
mysql_python_version: "3.9"
```

Python version used to install `python` and `pymysql` packages for Ansible database user management.

#### mysql_skip_networking

```yaml
mysql_skip_networking: false
```

Enable `skip-networking` in `my.cnf` to allow only local Unix socket connections.

#### mysql_socket

```yaml
mysql_socket: /var/run/mysql/mysql.sock
```

Path to the MariaDB Unix domain socket.
