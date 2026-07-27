provider "helm" {
  kubernetes = {
    host                   = module.talos.kubeconfig_data.host
    client_certificate     = module.talos.kubeconfig_data.client_certificate
    client_key             = module.talos.kubeconfig_data.client_key
    cluster_ca_certificate = module.talos.kubeconfig_data.cluster_ca_certificate
  }
}

provider "kubectl" {
  host                   = module.talos.kubeconfig_data.host
  client_certificate     = module.talos.kubeconfig_data.client_certificate
  client_key             = module.talos.kubeconfig_data.client_key
  cluster_ca_certificate = module.talos.kubeconfig_data.cluster_ca_certificate
  lazy_load              = true
  load_config_file       = false
}
