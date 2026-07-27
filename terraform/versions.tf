terraform {
  required_version = ">= 1.15.0"

  required_providers {
    imager = {
      source  = "hcloud-talos/imager"
      version = "1.0.17"
    }
  }
}
