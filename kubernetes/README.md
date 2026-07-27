# Kubernetes Baseline

This folder contains the baseline Kubernetes applications synced by Argo CD.

## Helm Charts

| Chart | Repository | Version | Namespace | Why it is included |
| --- | --- | --- | --- | --- |
| `cert-manager` | `https://charts.jetstack.io` | `1.21.0` | `cert-manager` | Provides certificate automation for future ingress, Gateway API, webhooks, and TLS-bearing platform services. |
| `argo-rollouts` | `https://argoproj.github.io/argo-helm` | `2.41.0` | `argo-rollouts` | Adds progressive delivery primitives such as blue-green and canary rollouts for apps that need safer deploy strategies later. |
