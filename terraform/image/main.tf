locals {
  talos_version = "v1.12.8"
}

resource "talos_image_factory_schematic" "hcloud" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = [
          "siderolabs/tailscale",
        ]
      }
    }
  })
}

resource "imager_image" "talos_x86" {
  image_url    = "https://factory.talos.dev/image/${talos_image_factory_schematic.hcloud.id}/${local.talos_version}/hcloud-amd64.raw.xz"
  architecture = "x86"

  labels = {
    os      = "talos"
    version = local.talos_version
  }

  lifecycle {
    prevent_destroy = true
  }
}
