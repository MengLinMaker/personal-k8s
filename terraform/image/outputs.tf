output "talos_image_id_x86" {
  description = "Hetzner snapshot image ID for the x86 Talos image with Tailscale baked in."
  value       = imager_image.talos_x86.image_id
}
