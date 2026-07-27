locals {
  talos_version = "v1.12.8"

  scalr_admin_cidrs = [
    for ip in split("\n", trimspace(data.http.scalr_ips_allowlist.response_body)) :
    "${ip}/32"
  ]

  admin_cidrs = concat(var.allowed_admin_cidrs, local.scalr_admin_cidrs)
}

data "http" "scalr_ips_allowlist" {
  url = "https://scalr.io/.well-known/allowlist.txt"
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
  firewall_kube_api_source  = local.admin_cidrs
  firewall_talos_api_source = local.admin_cidrs
  extra_firewall_rules = [
    {
      description = "Allow Incoming Requests to Headlamp"
      direction   = "in"
      protocol    = "tcp"
      port        = "30080"
      source_ips  = local.admin_cidrs
    }
  ]

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
  timeout          = 900
  wait             = false

  values = [
    yamlencode({
      configs = {
        cm = {
          "timeout.reconciliation"      = "300s"
          "timeout.hard.reconciliation" = "600s"
        }
      }

      dex = {
        enabled = false
      }

      notifications = {
        enabled = false
      }

      applicationSet = {
        enabled = false
      }

      controller = {
        resources = {
          requests = {
            cpu    = "50m"
            memory = "256Mi"
          }
          limits = {
            cpu    = "400m"
            memory = "512Mi"
          }
        }
      }

      repoServer = {
        resources = {
          requests = {
            cpu    = "25m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      server = {
        resources = {
          requests = {
            cpu    = "25m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      redis = {
        resources = {
          requests = {
            cpu    = "25m"
            memory = "64Mi"
          }
          limits = {
            cpu    = "150m"
            memory = "128Mi"
          }
        }
      }
    })
  ]

  depends_on = [module.talos]
}

resource "kubectl_manifest" "argocd_root" {
  validate_schema = false

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
