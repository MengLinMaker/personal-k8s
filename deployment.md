# Deployment

Deployment is layered:

1. OpenTofu creates a Hetzner Talos image with the Tailscale extension baked in.
2. OpenTofu provisions Hetzner infrastructure using that Talos image.
3. Talos boots and forms the Kubernetes cluster.
4. Cilium is installed as the Kubernetes CNI.
5. OpenTofu installs Argo CD with Helm.
6. OpenTofu creates the root Argo CD Application.
7. Argo CD pulls `kubernetes/` from this repo.
8. Argo CD installs baseline controllers such as cert-manager and Argo Rollouts.

## OpenTofu Stacks

There are two OpenTofu stacks:

| Stack | Path | Purpose |
| --- | --- | --- |
| Image | `terraform/image` | Creates a Hetzner Talos snapshot image with required Talos system extensions. |
| Cluster | `terraform/cluster` | Creates the Hetzner/Talos/Kubernetes cluster from a known snapshot image ID. |

The split exists because the cluster module needs the Talos image ID during planning. The image ID is only known after the image stack applies, so the cluster stack consumes it as an input.

Hetzner booting from a snapshot image is the preferred path here because it is fast and repeatable. Alternatives are less suitable:

- Packer can build a custom image, but it is slower and adds another build tool.
- Hetzner's built-in Talos ISO is simpler, but lacks custom Talos system extensions such as Tailscale.
