# wireguard

Configure [WireGuard](https://www.wireguard.com/) tunnel interfaces on FreeBSD and Debian. The role installs `wireguard-tools`, renders `wg.conf(5)` configuration, and enables the interface.

## Supported platforms

- FreeBSD
- Debian

## Variables

#### wireguard_addresses

```yaml
wireguard_addresses:
  - 192.0.2.1/24
```

Addresses assigned to the tunnel interface.

#### wireguard_dns

```yaml
wireguard_dns: []
```

DNS servers written to the `[Interface]` section.

#### wireguard_interface

```yaml
wireguard_interface: wg0
```

Name of the tunnel interface.

#### wireguard_mtu

```yaml
wireguard_mtu:
```

Optional MTU for the tunnel interface.

#### wireguard_peers

```yaml
wireguard_peers: []
```

List of peers. Each entry may contain:

- `name`: comment written above the peer section
- `allowed_ips`: list of routed networks or addresses
- `endpoint`: remote `host:port`
- `public_key`: peer public key
- `persistent_keepalive`: keepalive interval in seconds

#### wireguard_port

```yaml
wireguard_port: 51820
```

UDP port the interface listens on.

#### wireguard_post_down

#### wireguard_post_up

#### wireguard_pre_down

#### wireguard_pre_up

```yaml
wireguard_post_up:
```

Optional commands run by `wg-quick`. Set a string or a list of strings.

#### wireguard_private_key

```yaml
wireguard_private_key:
```

Private key of the local interface. Keep it in an encrypted variable file.

#### wireguard_relay

```yaml
wireguard_relay: false
```

Enable IP forwarding so the host routes traffic between the tunnel and other networks.

#### wireguard_table

```yaml
wireguard_table:
```

Optional routing table policy written to the `[Interface]` section.
