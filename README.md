# Personal Kubernetes
Provisioning a kubernertes cluster for personal project.

## Technologies
Technologies are chosen to form a base layer that can be used for other projects.

- Terraform - to provision infrastructure
- Talos - Operating system with K8s preinstalled
- Cilium - K8s CNI - also for eBPF observability
- ArgoCD - to deploy to cluster using gitops
- Helm - to install prepackaged K8s configs
