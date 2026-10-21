# PHP-FPM

Install PHP and extensions, configure php.ini and the FPM pool, and supervise
PHP-FPM with s6.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Pool settings

`php_fpm_version` selects the PHP package series and defaults to `php82`.
`php_fpm_address` defaults to `0.0.0.0:9000`. Set a Unix socket path to use
a local socket.

The pool uses dynamic process management. `php_fpm_max_children` defaults
to `5`, and `php_fpm_max_requests` defaults to `1000`.
Use `php_fpm_config` for additional pool directives.

## Resource and input limits

Set these role variables in inventory to change the limits:

| Variable | Default |
|----------|---------|
| `php_memory_limit` | 512M |
| `php_max_execution_time` | 120 |
| `php_max_input_time` | 60 |
| `php_post_max_size` | 144M |
| `php_upload_max_filesize` | 128M |
| `php_max_input_nesting_level` | 32 |
| `php_max_input_vars` | 1000 |
| `php_max_file_uploads` | 20 |
| `php_max_multipart_body_parts` | Input variables plus file uploads |

Input and upload limits are set in php.ini and enforced in the FPM pool
with `php_admin_value`. Applications and .user.ini cannot override the pool
limits. Configure frontend request body limits separately.

Session upload progress is disabled in php.ini and administratively in FPM.
Fatal error backtraces are disabled in both configurations for PHP 8.5 and
later. These settings and the pool limits are independent of `php_fpm_config`.
Do not repeat these directives in the custom block.

Configuration changes notify the PHP-FPM restart handler. The role validates
the pool configuration with `php-fpm -t` before replacement and keeps a backup.
