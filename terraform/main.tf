locals {
  talos_schematic_id = "ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515"
  talos_version      = "v1.12.8"
}

resource "imager_image" "talos_x86" {
  image_url    = "https://factory.talos.dev/image/${local.talos_schematic_id}/${local.talos_version}/hcloud-amd64.raw.xz"
  architecture = "x86"

  labels = {
    version = local.talos_version
  }

  lifecycle {
    prevent_destroy = true
  }
}

module "talos" {
  source  = "hcloud-talos/talos/hcloud"
  version = "3.4.13"

  hcloud_token       = var.hcloud_token
  cluster_name       = "personal-k8s"
  location_name      = "fsn1"
  talos_version      = local.talos_version
  kubernetes_version = "1.35.6"
  talos_image_id_x86 = imager_image.talos_x86.image_id

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
