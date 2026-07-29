# Personal Infrastructure

Base infrastructure experiments for personal projects.

## Stacks

| Stack | Path | Purpose |
| --- | --- | --- |
| Dokploy | `hetzner-dokploy` | Hetzner VPS running Dokploy on Docker Swarm. |
| k3s | `hetzner-k3s` | Single-node Kubernetes experiment using `vitobotta/hetzner-k3s`. |

## Commands

List root tasks:

```sh
task
```

Each stack also has its own Taskfile:

```sh
cd hetzner-dokploy && task
cd hetzner-k3s && task
```
