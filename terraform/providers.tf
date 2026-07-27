provider "imager" {
  token = var.hcloud_token
}

provider "helm" {
  kubernetes = {
    host                   = module.talos.kubeconfig_data.host
    client_certificate     = base64decode(module.talos.kubeconfig_data.client_certificate)
    client_key             = base64decode(module.talos.kubeconfig_data.client_key)
    cluster_ca_certificate = base64decode(module.talos.kubeconfig_data.cluster_ca_certificate)
  }
}
