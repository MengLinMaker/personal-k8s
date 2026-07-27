locals {
  talos_version = "v1.12.8"
}

module "talos" {
  source  = "hcloud-talos/talos/hcloud"
  version = "3.4.13"

  hcloud_token       = var.hcloud_token
  cluster_name       = "personal-k8s"
  location_name      = "fsn1"
  talos_version      = local.talos_version
  kubernetes_version = "1.35.6"
  talos_image_id_x86 = var.talos_image_id_x86
  tailscale = {
    enabled  = true
    auth_key = var.tailscale_auth_key
  }

  disable_arm = true

  firewall_use_current_ip   = false
  firewall_kube_api_source  = var.allowed_admin_cidrs
  firewall_talos_api_source = var.allowed_admin_cidrs

  control_plane_nodes = [
    {
      id     = 1
      type   = "cpx12"
      labels = var.labels
    }
  ]

  control_plane_allow_schedule = true
  deploy_cilium                = true
  worker_nodes                 = []
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.5.7"
  namespace        = "argocd"
  create_namespace = true

  depends_on = [module.talos]
}

resource "kubectl_manifest" "argocd_root" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "personal-k8s-platform"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/MengLinMaker/personal-k8s.git"
        targetRevision = "main"
        path           = "kubernetes"
        directory = {
          recurse = true
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  })

  depends_on = [helm_release.argocd]
}
