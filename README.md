# netdebug

A lightweight network inspection image built on `debian:stable-slim`, designed for ephemeral debugging sessions in Kubernetes clusters.

---

## Included tools

| Tool | Package | Purpose |
|---|---|---|
| `curl`, `wget` | `curl`, `wget` | HTTP/HTTPS request testing |
| `ping` | `iputils-ping` | ICMP reachability checks |
| `traceroute`, `mtr` | `traceroute`, `mtr` | Routing path inspection |
| `dig`, `nslookup` | `dnsutils` | DNS resolution debugging |
| `nmap` | `nmap` | Port scanning and service discovery |
| `tcpdump` | `tcpdump` | Packet capture (requires `--privileged`) |
| `netstat` | `net-tools` | Socket and connection listing |
| `ss`, `ip` | `iproute2` | Modern socket/interface inspection |
| `iperf3` | `iperf3` | Network bandwidth testing |
| `nc` | `netcat-openbsd` | TCP/UDP connectivity and port probing |

---

## Build

```bash
docker build -t your-repo/netdebug:latest .
docker push your-repo/netdebug:latest
```

---

## Usage

### Kubernetes — standard session

Launches an ephemeral pod that is automatically removed when you exit.

```bash
kubectl run netdebug \
  --image=your-repo/netdebug:latest \
  --rm -it \
  --restart=Never
```

### Kubernetes — privileged session (tcpdump / raw sockets)

```bash
kubectl run netdebug \
  --image=your-repo/netdebug:latest \
  --rm -it \
  --restart=Never \
  --privileged \
  -- bash
```

### Kubernetes — specific namespace

```bash
kubectl run netdebug \
  --image=your-repo/netdebug:latest \
  --rm -it \
  --restart=Never \
  -n your-namespace
```

### Kubernetes — pin to a specific node

```bash
kubectl run netdebug \
  --image=your-repo/netdebug:latest \
  --rm -it \
  --restart=Never \
  --overrides='{"spec":{"nodeName":"node-1"}}'
```

### Docker (local)

```bash
docker run --rm -it your-repo/netdebug:latest
```

---

## Security

The container runs as a non-root user (`netdebug`) by default. This is safe for most inspection tasks but restricts operations that require elevated capabilities.

| Capability needed | How to enable |
|---|---|
| `tcpdump`, raw sockets | Add `--privileged` flag |
| Run as root | Add `-u root` or `--user root` |

Avoid leaving privileged pods running unattended. The `--rm` flag ensures the pod is deleted when the session ends.

---

## Common one-liners

```bash
# Test DNS resolution
dig kubernetes.default.svc.cluster.local

# Check connectivity to a service
curl -v http://my-service.my-namespace.svc.cluster.local:8080/health

# Scan open ports on a pod IP
nmap -p 1-65535 10.0.0.42

# Probe a TCP port
nc -zv my-service 5432

# Capture traffic on eth0
tcpdump -i eth0 -n port 80

# Measure bandwidth between two pods (run iperf3 server on one pod first)
iperf3 -c <server-pod-ip>

# Trace the route to an external host
mtr --report google.com
```

---

## Base image

`debian:stable-slim` — minimal Debian stable with no extras beyond what is explicitly installed. The apt cache is cleared after installation to keep the image size down.
