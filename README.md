# Personal Kubernetes

Provisioning a Kubernetes cluster for personal projects.

## Technologies

Technologies are chosen to form a base layer that can be used for other projects.

- Terraform - to provision infrastructure
- Talos - Operating system with K8s preinstalled
- Cilium - K8s CNI - also for eBPF observability
- ArgoCD - to deploy to cluster using gitops
- Helm - to install prepackaged K8s configs

## Dependencies

Install the local tools:

```sh
brew install go-task/tap/go-task terraform helm kubectl talosctl
```

You also need a Hetzner Cloud API token with read/write access to the project.

## Configuration

Copy the example variables file and fill in the token and allowed admin CIDRs:

```sh
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

`terraform/terraform.tfvars` is ignored by git because it contains secrets and local network details.

## Commands

List available tasks:

```sh
task
```
