# pf

Configure the `pf` packet filter firewall on FreeBSD and OpenBSD.

The role validates `/etc/pf.conf` with `pfctl -n -f` before loading rules and preserves active state table entries on reload (`pfctl -f /etc/pf.conf`).

## Supported platforms

- FreeBSD
- OpenBSD

## Variables

#### pf_allow_ipv4

```yaml
pf_allow_ipv4: true
```

OpenBSD only. Enable IPv4 filtering rules on `pf_ext_iface`.

#### pf_allow_ipv6

```yaml
pf_allow_ipv6: false
```

OpenBSD only. Enable IPv6 filtering rules on `pf_ext_iface`.

#### pf_allowed_ifaces

```yaml
pf_allowed_ifaces: []
```

OpenBSD only. List of interfaces to pass all inbound traffic on (`pass in on <iface> inet/inet6 all`).

#### pf_allowed_ports

```yaml
pf_allowed_ports: []
```

OpenBSD only. List of ports allowed inbound on `pf_ext_iface`:

- `proto` — protocol (`tcp` or `udp`)
- `port` — destination port
- `source` — optional source address or CIDR (default: `any`)

#### pf_anchors

```yaml
pf_anchors: []
```

Wildcard filter anchors to include as `anchor "<name>/*"`.

#### pf_anchors_single

```yaml
pf_anchors_single: []
```

FreeBSD only. Exact filter anchors to include as `anchor <name>`.

#### pf_ext_iface

```yaml
pf_ext_iface: vio0
```

OpenBSD only. Primary external network interface.

#### pf_ipv4_forwarded_ports

```yaml
pf_ipv4_forwarded_ports: []
```

OpenBSD only. List of IPv4 port redirection rules on `pf_ext_iface`:

- `proto` — protocol (`tcp` or `udp`)
- `source` — optional source address or CIDR (default: `any`)
- `port` — external destination port on `pf_ext_iface`
- `address` — internal target IPv4 address (`rdr-to`)
- `dest_port` — internal target port

#### pf_ipv4_ifaces

```yaml
pf_ipv4_ifaces: []
```

FreeBSD only. See [Configuring Interfaces (FreeBSD)](#configuring-interfaces-freebsd) below.

#### pf_ipv4_nat

```yaml
pf_ipv4_nat: []
```

OpenBSD only. List of source IPv4 addresses or CIDRs to NAT outbound on `pf_ext_iface`.

#### pf_ipv6_forwarded_ports

```yaml
pf_ipv6_forwarded_ports: []
```

OpenBSD only. List of IPv6 port redirection rules on `pf_ext_iface` (same format as `pf_ipv4_forwarded_ports`).

#### pf_ipv6_ifaces

```yaml
pf_ipv6_ifaces: []
```

FreeBSD only. See [Configuring Interfaces (FreeBSD)](#configuring-interfaces-freebsd) below.

#### pf_load

```yaml
pf_load: true
```

FreeBSD only. Load the `pf` kernel module and enable `pf_load=YES` in `/boot/loader.conf`. Set this to `false` inside VNET jails.

#### pf_nat_anchors

```yaml
pf_nat_anchors: []
```

FreeBSD only. Wildcard NAT anchors to include as `nat-anchor "<name>/*"`.

#### pf_nat_anchors_single

```yaml
pf_nat_anchors_single: []
```

FreeBSD only. Exact NAT anchors to include as `nat-anchor <name>`.

#### pf_rdr_anchors

```yaml
pf_rdr_anchors: []
```

FreeBSD only. Wildcard redirection anchors to include as `rdr-anchor "<name>/*"`.

#### pf_rdr_anchors_single

```yaml
pf_rdr_anchors_single: []
```

FreeBSD only. Exact redirection anchors to include as `rdr-anchor <name>`.

#### pf_ssh_port

```yaml
pf_ssh_port: 22
```

SSH port to allow on interfaces with `allow_ssh: true` (FreeBSD) or on `pf_ext_iface` (OpenBSD). Set to `false` on FreeBSD to disable the default SSH rule.

## Configuring Interfaces (FreeBSD)

On FreeBSD, `pf_ipv4_ifaces` and `pf_ipv6_ifaces` configure per-interface rules in YAML format:

```yaml
pf_ipv4_ifaces:
  - iface: vtnet0
    allow_ssh: true
    allowed_ports:
      - proto: tcp
        source: 192.168.1.0/24
        to_address: 192.168.1.1
        to_port: 80
    forwarded_ports:
      - proto: tcp
        to_address: 192.168.1.1
        to_port: 80
        dest_address: 192.168.50.1
        dest_port: 8080
    nat:
      - 192.168.50.0/24
    pass: false

pf_ipv6_ifaces:
  - iface: vtnet1
    allow_ssh: true
    allowed_ports:
      - proto: tcp
        source: fc00::/7
        to_address: fc00::1
        to_port: 80
    forwarded_ports:
      - proto: tcp
        to_address: 2001:db8::1
        to_port: 80
        dest_address: 2001:db8::e8f4
        dest_port: 8080
    pass: false
```

#### iface

```yaml
iface: vtnet0
```

Interface name to apply the configuration to.

#### allow_ssh

```yaml
allow_ssh: false
```

Allow incoming TCP connections to `pf_ssh_port` on this interface.

#### allowed_ports

```yaml
allowed_ports:
  - proto: tcp
    source: 192.168.1.0/24
    to_address: 192.168.1.1
    to_port: 80
```

Allow incoming connections on this interface:

- `proto` — protocol (`tcp`, `udp`, etc.; optional)
- `source` — source IP or CIDR (default: `any`)
- `to_address` — destination IP (default: `any`)
- `to_port` — destination port (optional)

#### forwarded_ports

```yaml
forwarded_ports:
  - proto: tcp
    to_address: 192.168.1.1
    to_port: 80
    dest_address: 192.168.50.1
    dest_port: 8080
```

Redirect incoming traffic (`rdr pass`) on this interface:

- `proto` — protocol (`tcp` or `udp`)
- `source` — source IP or CIDR (default: `any`)
- `to_address` — destination IP (default: `iface`)
- `to_port` — external destination port
- `dest_address` — target redirection IP
- `dest_port` — target redirection port

#### nat

```yaml
nat:
  - 192.168.50.0/24
```

**IPv4 only.** Enable outbound NAT (`nat on <iface>`) for the given IPv4 address or CIDR.

#### pass

```yaml
pass: false
```

Pass all inbound traffic on this interface (`pass in on <iface> inet/inet6 all`). Useful for internal or jail interfaces.
