# vlagent

Install and configure vlagent for file collection and queued log delivery.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host. AMD64 and ARM64 are supported.

## Configuration

Set `vlagent_remote_write_url` to the VictoriaLogs `/insert/native` endpoint.
Set `vlagent_file_glob` to JSON log files readable by the `vlagent` user.
Do not include an s6 timestamp prefix or compressed files. Select current
files, not all rotated files, to avoid replaying old logs.

- `vlagent_listen_address`: `127.0.0.1:9429`.
- `vlagent_data_dir`: `/var/db/vlagent`, for queues and checkpoints.
- `vlagent_max_disk_usage_per_url`: `1GiB`. Old blocks can be dropped
  at this limit.
- `vlagent_memory_allowed_bytes`: `128MiB` cache budget, not a process limit.
- `vlagent_extra_fields`: `{}`. Set stable host and job fields.
- `vlagent_stream_fields`: `[host, job]`. Do not use paths or client addresses.
- `vlagent_time_field`: `time`.
- `vlagent_msg_field`: `message`.

Keep queues and checkpoints across restarts. Abrupt stops can replay rows.
Source files deleted before collection cannot be recovered.

Ansible builds vlagent v1.53.0 on the host when `vlagent_binary_src`
is absent. It installs `go127`, `gmake`, and `gtar` from pkg and verifies
the source archive checksum. The host needs network access for the first
build. Build files and binaries are cached under `/var/cache/`.
Check mode reports missing builds without compiling or changing the host.
For version updates, update the source checksum.
