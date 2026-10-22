# rke2

Install and configure [RKE2](https://docs.rke2.io/) server or agent nodes.

## Supported platforms

- Debian

## Variables

#### rke2_agent_node_labels

```yaml
rke2_agent_node_labels: []
```

Node labels applied by agent nodes.

#### rke2_agent_node_taints

```yaml
rke2_agent_node_taints: []
```

Node taints applied by agent nodes.

#### rke2_extra_args

```yaml
rke2_extra_args: {}
```

Extra keys written verbatim to `/etc/rancher/rke2/config.yaml`.

#### rke2_role

```yaml
rke2_role: server
```

Role of the node. Set `server` or `agent`.

#### rke2_server_cluster_cidr

```yaml
rke2_server_cluster_cidr: 10.42.0.0/16
```

Server only. Pod network CIDR.

#### rke2_server_disable

```yaml
rke2_server_disable: []
```

Server only. Packaged components to disable, for example `rke2-ingress-nginx`.

#### rke2_server_node_taints

```yaml
rke2_server_node_taints: []
```

Server only. Node taints applied by the server.

#### rke2_server_service_cidr

```yaml
rke2_server_service_cidr: 10.43.0.0/16
```

Server only. Service network CIDR.

#### rke2_server_tls_san

```yaml
rke2_server_tls_san: []
```

Server only. Extra Subject Alternative Names for the API server certificate.

#### rke2_server_url

```yaml
rke2_server_url:
```

Agent only. Registration address of the server, for example `https://server.example.com:9345`.

#### rke2_server_write_kubeconfig_mode

```yaml
rke2_server_write_kubeconfig_mode: "0640"
```

Server only. File mode of the generated kubeconfig.

#### rke2_token

```yaml
rke2_token:
```

Agent only. Cluster join token. Keep it in an encrypted variable file.

#### rke2_version

```yaml
rke2_version: stable
```

RKE2 release channel or version passed to the installer.
