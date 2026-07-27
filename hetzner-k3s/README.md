# Single-node hetzner-k3s Experiment

This is a lean Kubernetes experiment using `vitobotta/hetzner-k3s`:

- one `cpx12` master node
- workloads scheduled on the master
- Cilium CNI for better production debugging and network visibility
- no Argo Rollouts
- no metrics stack by default
- Flux for low-overhead GitOps

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
- `GITHUB_TOKEN`
- `GITHUB_USER`

Edit `cluster.yaml`:

- check `allowed_networks`
- optionally change `instance_type` from `cpx12` to `cpx22`

From the repository root, create the cluster:

```sh
task k3s:deploy
export KUBECONFIG=$PWD/hetzner-k3s/kubeconfig
kubectl get nodes
```

`k3s:deploy` always runs with `DEBUG=true` and skips hetzner-k3s current IP validation. Firewall access is still controlled by `allowed_networks` in `cluster.yaml`.

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

## Bootstrap Flux

From the repository root:

```sh
task k3s:flux
```

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
