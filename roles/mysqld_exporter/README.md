# mysqld_exporter

Install and configure MySQL Exporter for MySQL and MariaDB metrics.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

- `mysqld_exporter_listen_address`: `127.0.0.1:9104`.
- `mysqld_exporter_database_user`: `mysqld_exporter`.
- `mysqld_exporter_password`: required, from the caller's secret store.
- `mysqld_exporter_socket`: `mysql_socket` when defined, otherwise
  `/var/run/mysql/mysql.sock`.

Create the localhost database user separately, for example through
`mysql_databases` with `*.*:PROCESS,REPLICATION CLIENT,SELECT`.
The role creates the OS user and a client file with mode `0600`.
The socket must exist and be writable by `mysqld_exporter_user`.

Passwords cannot contain newlines, `$`, or triple double quotes.
The exporter expands environment variables in its INI values.
The client-file task suppresses output and diffs.
