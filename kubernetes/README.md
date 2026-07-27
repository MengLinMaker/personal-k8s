# Kubernetes Baseline

This folder contains the baseline Kubernetes applications synced by Argo CD.

## Helm Charts

| Chart | Repository | Version | Namespace | Why it is included |
| --- | --- | --- | --- | --- |
| `metrics-server` | `https://kubernetes-sigs.github.io/metrics-server/` | `3.13.1` | `kube-system` | Enables live CPU and memory readings for `kubectl top`, Headlamp, and lightweight cluster debugging. It is not a long-term monitoring store. |
| `headlamp` | `https://kubernetes-sigs.github.io/headlamp/` | `0.43.0` | `headlamp` | Provides a lightweight Kubernetes web UI for inspecting pods, nodes, logs, and events without installing a full monitoring stack. It is kept internal-only by default. |
| `cert-manager` | `https://charts.jetstack.io` | `1.21.0` | `cert-manager` | Provides certificate automation for future ingress, Gateway API, webhooks, and TLS-bearing platform services. |
| `argo-rollouts` | `https://argoproj.github.io/argo-helm` | `2.41.0` | `argo-rollouts` | Adds progressive delivery primitives such as blue-green and canary rollouts for apps that need safer deploy strategies later. |
