# vmagent

Install and configure vmagent for metrics scraping and queued remote write.

## Supported platforms

- FreeBSD with s6 supervision (`s6: true`).

The `s6` role must be configured on the host.

## Configuration

Set `vmagent_remote_write_url` to the remote-write endpoint.
Set `vmagent_scrape_configs` to a list of Prometheus scrape jobs.
`vmagent_global` defaults to a 30-second scrape interval and an external
`host` label from `ansible_hostname`. The executable validates the scrape
configuration before replacement.

- `vmagent_listen_address`: `127.0.0.1:8429`.
- `vmagent_data_dir`: `/var/db/vmagent`, for the persistent write queue.
- `vmagent_max_disk_usage_per_url`: `1GB`. The oldest queued samples are
  dropped when this limit is reached.
- `vmagent_memory_allowed_bytes`: `128MiB` cache budget, not a process
  memory limit.

The scrape configuration is stored with mode `0600`. Its task output and
diffs are suppressed because scrape jobs can contain credentials.
