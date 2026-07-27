# Personal Kubernetes

Provisioning a Kubernetes cluster for personal projects.

## Deployment Flow

Technologies are chosen to form a base layer that can be used for other projects.

Deployment is layered:

1. OpenTofu provisions Hetzner infrastructure and the Talos image.
2. Talos boots and forms the Kubernetes cluster.
3. Cilium is installed as the Kubernetes CNI.
4. OpenTofu installs Argo CD with Helm.
5. OpenTofu creates the root Argo CD Application.
6. Argo CD pulls `kubernetes/` from this repo.
7. Argo CD installs baseline controllers such as cert-manager and Argo Rollouts.

## Dependencies

Install the local tools:

```sh
brew install go-task/tap/go-task opentofu helm kubectl talosctl
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
