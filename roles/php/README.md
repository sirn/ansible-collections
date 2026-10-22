# php

Install [PHP](https://www.php.net/) and extensions, and configure `php.ini` and the PHP-FPM pool.

Input and upload limits are set in `php.ini` and enforced in the FPM pool with `php_admin_value`. Applications and `.user.ini` cannot override the pool limits. Session upload progress is disabled in `php.ini` and administratively in FPM. Fatal error backtraces are disabled in both configurations for PHP 8.5 and later. Do not repeat these directives in `php_fpm_config`.

The role validates the pool configuration with `php-fpm -t -y` before replacement and keeps a backup.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### php_fpm_address

```yaml
php_fpm_address: 0.0.0.0:9000
```

Listen address for PHP-FPM. Set either a TCP `address:port` or a Unix socket path (for example `/var/run/php-fpm/php-fpm.sock`).

#### php_fpm_config

```yaml
php_fpm_config:
```

Extra PHP-FPM pool directives appended to `/usr/local/etc/php-fpm.d/www.conf`:

```yaml
php_fpm_config: |
  env[HOSTNAME] = $HOSTNAME
  env[PATH] = /usr/local/bin:/usr/bin:/bin
  env[TEMP] = /tmp
  env[TMPDIR] = /tmp
  env[TMP] = /tmp
```

#### php_fpm_logger

```yaml
php_fpm_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/php-fpm/
```

Configure the PHP-FPM logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### php_fpm_max_children

```yaml
php_fpm_max_children: 5
```

Maximum number of child processes (`pm.max_children`).

#### php_fpm_max_requests

```yaml
php_fpm_max_requests: 1000
```

Number of requests each child process executes before respawning (`pm.max_requests`). Set to `0` for unlimited requests.

#### php_fpm_max_spare_servers

```yaml
php_fpm_max_spare_servers: 3
```

Maximum number of idle server processes when `php_fpm_pm` is `dynamic`.

#### php_fpm_min_spare_servers

```yaml
php_fpm_min_spare_servers: 1
```

Minimum number of idle server processes when `php_fpm_pm` is `dynamic`.

#### php_fpm_pm

```yaml
php_fpm_pm: dynamic
```

Process manager control mode (`static`, `ondemand`, or `dynamic`).

#### php_fpm_start_servers

```yaml
php_fpm_start_servers: 2
```

Number of child processes created on startup when `php_fpm_pm` is `dynamic`.

#### php_fpm_version

```yaml
php_fpm_version: php82
```

PHP package series to install from pkg (for example `php82`, `php84`, or `php85`). On `php85` and later, the separate `-opcache` package is skipped because OPcache is bundled.

#### php_max_execution_time

```yaml
php_max_execution_time: 120
```

Maximum time in seconds a script is allowed to run before termination (`max_execution_time`).

#### php_max_file_uploads

```yaml
php_max_file_uploads: 20
```

Maximum number of files allowed to be uploaded simultaneously (`max_file_uploads`). Enforced in `php.ini` and the FPM pool.

#### php_max_input_nesting_level

```yaml
php_max_input_nesting_level: 32
```

Maximum nesting depth of input variables (`max_input_nesting_level`). Enforced in `php.ini` and the FPM pool.

#### php_max_input_time

```yaml
php_max_input_time: 60
```

Maximum time in seconds a script is allowed to parse input data (`max_input_time`).

#### php_max_input_vars

```yaml
php_max_input_vars: 1000
```

Maximum number of input variables accepted per request (`max_input_vars`). Enforced in `php.ini` and the FPM pool.

#### php_max_multipart_body_parts

```yaml
php_max_multipart_body_parts: "{{ php_max_input_vars | int + php_max_file_uploads | int }}"
```

Maximum number of multipart body parts accepted per request (`max_multipart_body_parts`). Enforced in `php.ini` and the FPM pool.

#### php_memory_limit

```yaml
php_memory_limit: 512M
```

Maximum amount of memory a script may consume (`memory_limit`).

#### php_opcache_interned_strings_buffer

```yaml
php_opcache_interned_strings_buffer: 8
```

Amount of memory in megabytes allocated for interned strings (`opcache.interned_strings_buffer`).

#### php_opcache_max_accelerated_files

```yaml
php_opcache_max_accelerated_files: 10000
```

Maximum number of keys (scripts) in the OPcache hash table (`opcache.max_accelerated_files`).

#### php_opcache_memory_consumption

```yaml
php_opcache_memory_consumption: 128
```

OPcache shared memory storage size in megabytes (`opcache.memory_consumption`).

#### php_opcache_revalidate_freq

```yaml
php_opcache_revalidate_freq: 2
```

How often in seconds to check script timestamps for updates (`opcache.revalidate_freq`).

#### php_opcache_validate_timestamp

```yaml
php_opcache_validate_timestamp: 1
```

Enable (`1`) or disable (`0`) OPcache script timestamp validation (`opcache.validate_timestamps`).

#### php_post_max_size

```yaml
php_post_max_size: 144M
```

Maximum size of POST data accepted (`post_max_size`). Enforced in `php.ini` and the FPM pool. Configure frontend request body limits separately.

#### php_upload_max_filesize

```yaml
php_upload_max_filesize: 128M
```

Maximum size of an uploaded file (`upload_max_filesize`). Enforced in `php.ini` and the FPM pool.
