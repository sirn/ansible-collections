# openssh

Install and configure `openssh-portable`. On initial installation, the role stops the base `sshd` service, starts the s6-supervised `openssh` service, and waits for the SSH connection to recover.

## Supported platforms

- FreeBSD with [s6 supervision](../s6/README.md) (`s6: true`)

## Variables

#### openssh_addresses

```yaml
openssh_addresses:
  - "0.0.0.0"
  - "::"
```

List of addresses for `sshd` to listen on (`ListenAddress`).

#### openssh_allow_agent_forwarding

```yaml
openssh_allow_agent_forwarding: true
```

Configure `AllowAgentForwarding` in `/usr/local/etc/sshd_config`.

#### openssh_allow_tcp_forwarding

```yaml
openssh_allow_tcp_forwarding: true
```

Configure `AllowTcpForwarding` in `/usr/local/etc/sshd_config`.

#### openssh_copy_host_keys

```yaml
openssh_copy_host_keys: false
```

Copy existing host keys (`ecdsa`, `ed25519`, `rsa`) from `/etc/ssh/` to `/usr/local/etc/ssh/`. Missing host keys are generated with `/usr/local/bin/ssh-keygen -A`.

#### openssh_enable_sftp

```yaml
openssh_enable_sftp: false
```

Enable the `sftp` subsystem (`/usr/local/libexec/sftp-server`) in `/usr/local/etc/sshd_config`.

#### openssh_logger

```yaml
openssh_logger: |
  #!/usr/local/bin/execlineb -P
  s6-log -b n10 s1000000 t !"gzip -nq9" /var/log/openssh/
```

Configure the OpenSSH logger. See [s6-log](https://skarnet.org/software/s6/s6-log.html).

#### openssh_port

```yaml
openssh_port: 22
```

TCP port for `sshd` to listen on (`Port`).

#### openssh_print_motd

```yaml
openssh_print_motd: true
```

Configure `PrintMotd` in `/usr/local/etc/sshd_config`.
