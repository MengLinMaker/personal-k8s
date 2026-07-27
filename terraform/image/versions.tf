terraform {
  required_version = ">= 1.12.0, < 2.0.0"

  required_providers {
    imager = {
      source  = "hcloud-talos/imager"
      version = "1.0.17"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
  }
}
