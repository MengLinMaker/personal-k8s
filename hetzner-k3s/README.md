# Single-node hetzner-k3s Experiment

This is a lean Kubernetes experiment using `vitobotta/hetzner-k3s`:

- one `cpx12` master node
- workloads scheduled on the master
- Cilium CNI for better production debugging and network visibility
- no Argo Rollouts
- no metrics stack by default
- Flux for low-overhead app GitOps

## Install tools

```sh
brew install vitobotta/tap/hetzner_k3s fluxcd/tap/flux kubectl
```

## Create the cluster

Create a local environment file:

```sh
cp hetzner-k3s/.env.example hetzner-k3s/.env
```

Edit `hetzner-k3s/.env` and set:

- `HCLOUD_TOKEN`
- `K3S_HOST`

Edit `cluster.yaml`:

- check `allowed_networks`
- optionally change `instance_type` from `cpx12` to `cpx22`

From the repository root, create the cluster:

```sh
task k3s:bootstrap
export KUBECONFIG=$PWD/hetzner-k3s/kubeconfig
kubectl get nodes
```

`k3s:bootstrap` creates the cluster, ensures Flux is installed, then applies local platform registrations. `k3s:deploy` always runs with `DEBUG=true` and skips hetzner-k3s current IP validation. Firewall access is still controlled by `allowed_networks` in `cluster.yaml`.

SSH:

```sh
K3S_HOST=138.199.152.218 task k3s:ssh
```

Kubectl:

```sh
task k3s:kubectl -- get nodes
task k3s:kubectl -- top nodes
task k3s:kubectl -- top pods -A --sort-by=cpu
```

k9s:

```sh
task k3s:k9s
```

Hubble UI:

```sh
task k3s:hubble
```

Then open `http://localhost:12000`.

## Sync platform

Flux is installed by this repo, but it does not watch this repo. This keeps the base infrastructure repo as a manual admin tool and avoids a misconfigured Flux change breaking its own control plane.

After editing platform registrations, push them from the repository root:

```sh
task k3s:sync
```

Put Flux `GitRepository` and `Kustomization` resources for app repos under `hetzner-k3s/platform/apps`, then add them to `hetzner-k3s/platform/apps/kustomization.yaml`.

For public app repos, no GitHub token is needed. Flux can pull over HTTPS from the public repository. App repos can then own their own deployment manifests while this repo stays responsible for cluster creation and app registration.

Check baseline usage:

```sh
kubectl get pods -A
flux get all -A
```

Flux does not include a dashboard or metrics stack by default. Use `flux get ...`, Kubernetes events, and controller logs for debugging.

## Delete

Because `protect_against_deletion` is enabled, disable it in `cluster.yaml` before deleting:

```yaml
protect_against_deletion: false
```

Then:

```sh
task k3s:destroy
```
