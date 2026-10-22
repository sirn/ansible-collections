# tuning

Tune FreeBSD kernel, network, and boot parameters.

- RC: enable `clear_tmp_enable="YES"`
- TCP: configure congestion control algorithm (default: `htcp`) and network buffers
- Bootloader: disable GEOM disk ident/gptid labels, configure TCP syncache/tcbhashsize, and optionally disable TSC calibration
- Sysctl: adjust socket accept queue, `maxfiles`, `maxvnodes`, usermount, and `vtnet` LRO

Changes to `/boot/loader.conf` and kernel module settings trigger a system reboot.

## Supported platforms

- FreeBSD

## Variables

#### tuning_cc_algorithm

```yaml
tuning_cc_algorithm: htcp
```

TCP congestion control algorithm to load and enable. Must be one of:

- `chd` — see `man 4 cc_chd`
- `cubic` — see `man 4 cc_cubic`
- `hd` — see `man 4 cc_hd`
- `newreno` — see `man 4 cc_newreno`
- `vegas` — see `man 4 cc_vegas`
- `htcp` — see `man 4 cc_htcp`

When set to `htcp`, adaptive backoff and RTT scaling are enabled in `/boot/loader.conf`.

#### tuning_disable_tsc_calibration

```yaml
tuning_disable_tsc_calibration: false
```

Set `kern.timecounter.invariant_tsc=1` and `machdep.disable_tsc_calibration=1` in `/boot/loader.conf`.

#### tuning_lro_disable

```yaml
tuning_lro_disable: false
```

Disable Large Receive Offload (`hw.vtnet.lro_disable=1`) for `vtnet` interfaces in `/etc/sysctl.conf`.

#### tuning_soacceptqueue

```yaml
tuning_soacceptqueue: 1024
```

Configure the maximum listen socket queue size (`kern.ipc.soacceptqueue`) in `/etc/sysctl.conf`.

#### tuning_vfs_usermount

```yaml
tuning_vfs_usermount: false
```

Allow unprivileged users to mount filesystems (`vfs.usermount=1`) in `/etc/sysctl.conf`.
