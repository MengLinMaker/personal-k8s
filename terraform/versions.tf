terraform {
  required_version = ">= 1.12.0, < 2.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }

    imager = {
      source  = "hcloud-talos/imager"
      version = "1.0.17"
    }
  }
}
