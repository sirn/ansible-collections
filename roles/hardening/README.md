# hardening

Harden FreeBSD and OpenBSD hosts with [Lynis](https://cisofy.com/lynis/), SSH, privilege escalation permissions, sysctl, and process accounting.

- SSH: disable root login, agent forwarding, X11 forwarding, compression, and DNS lookups
- SSH: configure port, TCP forwarding, and `Match User` blocks
- Sudo / Doas: restrict configuration file permissions (`0600`)
- TTY: require root password in single-user mode on FreeBSD
- Bootloader: optionally disable Hyper-Threading on FreeBSD
- Sysctl: apply HardenedBSD kernel and network security settings on FreeBSD
- Accounting: enable process accounting (`/var/account/acct`)

## Supported platforms

- FreeBSD
- OpenBSD

## Variables

#### hardening_disable_ht

```yaml
hardening_disable_ht: false
```

FreeBSD only. Disable Hyper-Threading (`machdep.hyperthreading_allowed=0`) in `/boot/loader.conf` to mitigate speculative execution side-channel attacks. Enabling this triggers a system reboot.

#### hardening_ssh_allow_tcp_forwarding

```yaml
hardening_ssh_allow_tcp_forwarding: false
```

FreeBSD only. Set `AllowTcpForwarding` in `/etc/ssh/sshd_config`. On OpenBSD, `AllowTcpForwarding` is always set to `no`.

#### hardening_ssh_match_user

```yaml
hardening_ssh_match_user: {}
```

FreeBSD only. Dictionary of per-user `Match User` blocks to manage in `/etc/ssh/sshd_config`. For example:

```yaml
hardening_ssh_match_user:
  deploy:
    AllowTcpForwarding: "yes"
```

#### hardening_ssh_port

```yaml
hardening_ssh_port: 22
```

SSH port configured in `/etc/ssh/sshd_config`. Update the Ansible inventory port if you change this value.
