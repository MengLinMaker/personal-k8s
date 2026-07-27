# Personal Kubernetes

Provisioning a Kubernetes cluster for personal projects.

## Deployment Flow

Technologies are chosen to form a base layer that can be used for other projects.

Deployment is layered:

1. OpenTofu creates a Hetzner Talos image with the Tailscale extension baked in.
2. OpenTofu provisions Hetzner infrastructure using that Talos image.
3. Talos boots and forms the Kubernetes cluster.
4. Cilium is installed as the Kubernetes CNI.
5. OpenTofu installs Argo CD with Helm.
6. OpenTofu creates the root Argo CD Application.
7. Argo CD pulls `kubernetes/` from this repo.
8. Argo CD installs baseline controllers such as cert-manager and Argo Rollouts.

## Dependencies

Install the local tools:

```sh
brew install go-task/tap/go-task opentofu helm kubectl talosctl
```

You also need a Hetzner Cloud API token with read/write access to the project.

## Configuration

Copy the example variables files and fill in the required values:

```sh
cp terraform/image/terraform.tfvars.example terraform/image/terraform.tfvars
cp terraform/cluster/terraform.tfvars.example terraform/cluster/terraform.tfvars
```

`terraform.tfvars` files are ignored by git because they contain secrets and local network details.

Apply `terraform/image` first, then copy its `talos_image_id_x86` output into `terraform/cluster/terraform.tfvars`.

## Commands

List available tasks:

```sh
task
```
