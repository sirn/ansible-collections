# mysqld_exporter

Install and configure [MySQL Exporter](https://github.com/prometheus/mysqld_exporter) for MySQL and MariaDB metrics.

Create the localhost database user separately, for example through `mysql_databases` in [`mysql`](../mysql/README.md) with `*.*:PROCESS,REPLICATION CLIENT,SELECT`.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### mysqld_exporter_database_user

```yaml
mysqld_exporter_database_user: mysqld_exporter
```

MySQL username written to the exporter client configuration file.

#### mysqld_exporter_listen_address

```yaml
mysqld_exporter_listen_address: 127.0.0.1:9104
```

Address and port for the exporter HTTP listener.

#### mysqld_exporter_logger

```yaml
mysqld_exporter_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/mysqld_exporter/
```

Configure the MySQL Exporter logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### mysqld_exporter_password

```yaml
mysqld_exporter_password: ""
```

Required. Database password from the caller's secret store. Passwords cannot contain newlines, `$`, or triple double quotes because the exporter expands environment variables in its INI values. The client-file task suppresses output and diffs.

#### mysqld_exporter_socket

```yaml
mysqld_exporter_socket: "{{ mysql_socket | default('/var/run/mysql/mysql.sock') }}"
```

Path to the MySQL or MariaDB Unix socket. The socket must exist and be writable by `mysqld_exporter_user`.

#### mysqld_exporter_user

```yaml
mysqld_exporter_user: mysqld_exporter
```

OS user created to run the exporter and own the client credentials file.
